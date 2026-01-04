#!/usr/bin/env bash
# ------------------------------------------------------------
# Enhanced Zsh Setup Script with DAG-based Dependency Engine
# Safe, idempotent, cross-platform installer
# ------------------------------------------------------------

set -Eeuo pipefail

# -------------------------
# Colors
# -------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# -------------------------
# Helpers
# -------------------------
info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✖${NC} $*"; }
depinfo() { echo -e "${CYAN}→${NC} $*"; }

trap 'error "Setup failed. Aborting."' ERR

# -------------------------
# Item States
# -------------------------
declare -r STATE_PENDING="pending"
declare -r STATE_INSTALLED="installed"
declare -r STATE_SKIPPED="skipped"
declare -r STATE_BLOCKED="blocked"
declare -r STATE_FAILED="failed"

# State tracking: item_name -> state
declare -A ITEM_STATES

# Dependency tracking: item_name -> "dep1 dep2 dep3"
declare -A ITEM_DEPENDENCIES

# Item metadata: item_name -> "description|optional|install_func"
declare -A ITEM_METADATA

# Blocked items tracking: item_name -> "reason"
declare -A BLOCKED_REASONS

# -------------------------
# OS Detection
# -------------------------
OS="$(uname -s)"
case "$OS" in
  Darwin) OS_TYPE="macos" ;;
  Linux)  OS_TYPE="linux" ;;
  *)
    error "Unsupported OS: $OS"
    exit 1
    ;;
esac

info "Detected OS: $OS_TYPE"

# -------------------------
# Paths
# -------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_SOURCE="$SCRIPT_DIR/zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
TMUX_CONF_SOURCE="$SCRIPT_DIR/tmux.conf"
TMUX_CONF_TARGET="$HOME/.tmux.conf"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# -------------------------
# Pre-flight checks
# -------------------------
command -v git >/dev/null || { error "git is required"; exit 1; }
command -v curl >/dev/null || { error "curl is required"; exit 1; }

if ! command -v zsh >/dev/null; then
  warn "Zsh not found. Please install it manually:"
  if [ "$OS_TYPE" = "macos" ]; then
    echo "  brew install zsh"
  else
    echo "  sudo apt install zsh"
  fi
  exit 1
fi

# -------------------------
# User Input
# -------------------------
ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"
  local response

  while true; do
    if [ "$default" = "y" ]; then
      read -p "$(echo -e "${BLUE}?${NC} $prompt [Y/n]: ")" response
    else
      read -p "$(echo -e "${BLUE}?${NC} $prompt [y/N]: ")" response
    fi
    
    response=${response:-$default}
    case "$response" in
      [Yy]* ) return 0 ;;
      [Nn]* ) return 1 ;;
      * ) echo "Please answer yes or no." ;;
    esac
  done
}

# -------------------------
# DAG Functions
# -------------------------

# Get all items that depend on a given item
get_dependents() {
  local item="$1"
  local dependent
  local deps
  
  for dependent in "${!ITEM_DEPENDENCIES[@]}"; do
    deps="${ITEM_DEPENDENCIES[$dependent]}"
    if [[ " $deps " == *" $item "* ]]; then
      echo "$dependent"
    fi
  done
}

# Mark item and all dependents as blocked
mark_blocked_cascade() {
  local item="$1"
  local reason="$2"
  local visited=()
  local stack=("$item")
  local current
  local dependents
  
  while [ ${#stack[@]} -gt 0 ]; do
    current="${stack[-1]}"
    stack=("${stack[@]:0:$((${#stack[@]}-1))}")
    
    # Skip if already visited
    [[ " ${visited[*]} " == *" $current "* ]] && continue
    visited+=("$current")
    
    # Mark as blocked if not already installed
    if [ "${ITEM_STATES[$current]:-$STATE_PENDING}" != "$STATE_INSTALLED" ]; then
      ITEM_STATES[$current]="$STATE_BLOCKED"
      BLOCKED_REASONS[$current]="$reason"
    fi
    
    # Add dependents to stack
    readarray -t dependents < <(get_dependents "$current")
    for dep in "${dependents[@]}"; do
      if [[ " ${visited[*]} " != *" $dep "* ]]; then
        stack+=("$dep")
      fi
    done
  done
}

# Validate all dependencies are satisfied
validate_dependencies() {
  local item="$1"
  local deps="${ITEM_DEPENDENCIES[$item]:-}"
  local dep
  local missing_deps=()
  
  if [ -z "$deps" ]; then
    return 0
  fi
  
  for dep in $deps; do
    local dep_state="${ITEM_STATES[$dep]:-$STATE_PENDING}"
    if [ "$dep_state" != "$STATE_INSTALLED" ]; then
      missing_deps+=("$dep ($dep_state)")
    fi
  done
  
  if [ ${#missing_deps[@]} -gt 0 ]; then
    local missing_list=$(IFS=', '; echo "${missing_deps[*]}")
    error "Item '$item' has unmet dependencies: $missing_list"
    mark_blocked_cascade "$item" "Unmet dependencies: $missing_list"
    return 1
  fi
  
  return 0
}

# Topological sort using Kahn's algorithm
topological_sort() {
  local sorted=()
  local queue=()
  declare -A in_degree_count
  local item
  local deps
  local dep
  local dependent
  
  # Initialize in-degree counts for all items
  for item in "${!ITEM_DEPENDENCIES[@]}"; do
    in_degree_count[$item]=0
  done
  
  # Count in-degrees (how many dependencies each item has)
  for item in "${!ITEM_DEPENDENCIES[@]}"; do
    deps="${ITEM_DEPENDENCIES[$item]:-}"
    if [ -n "$deps" ]; then
      for dep in $deps; do
        # Only count dependencies that are items we're tracking
        if [ -n "${ITEM_DEPENDENCIES[$dep]:-}" ] || [ -n "${ITEM_METADATA[$dep]:-}" ]; then
          in_degree_count[$item]=$((${in_degree_count[$item]} + 1))
        fi
      done
    fi
  done
  
  # Add items with zero in-degree to queue (items with no dependencies)
  for item in "${!ITEM_DEPENDENCIES[@]}"; do
    if [ ${in_degree_count[$item]:-0} -eq 0 ]; then
      queue+=("$item")
    fi
  done
  
  # Process queue
  while [ ${#queue[@]} -gt 0 ]; do
    item="${queue[0]}"
    queue=("${queue[@]:1}")
    sorted+=("$item")
    
    # Find all items that depend on this item and reduce their in-degree
    for dependent in "${!ITEM_DEPENDENCIES[@]}"; do
      deps="${ITEM_DEPENDENCIES[$dependent]}"
      if [[ " $deps " == *" $item "* ]]; then
        in_degree_count[$dependent]=$((${in_degree_count[$dependent]} - 1))
        if [ ${in_degree_count[$dependent]} -eq 0 ]; then
          queue+=("$dependent")
        fi
      fi
    done
  done
  
  # Check for cycles (if not all items were processed, there's a cycle)
  local total_items=$(printf '%s\n' "${!ITEM_DEPENDENCIES[@]}" | wc -l | tr -d ' ')
  if [ ${#sorted[@]} -ne "$total_items" ]; then
    error "Dependency cycle detected in item definitions!"
    error "Processed ${#sorted[@]} items, but ${total_items} items defined"
    exit 1
  fi
  
  printf '%s\n' "${sorted[@]}"
}

# -------------------------
# Installation Functions
# -------------------------

install_homebrew() {
  if [ "$OS_TYPE" != "macos" ]; then
    # Not applicable on Linux, but this shouldn't be called
    error "Homebrew installation attempted on non-macOS system"
    return 1
  fi
  
  if ! command -v brew >/dev/null; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
  ITEM_STATES["homebrew"]="$STATE_INSTALLED"
  return 0
}

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh"
    RUNZSH=no CHSH=no sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    success "Oh My Zsh installed"
  else
    success "Oh My Zsh already installed"
  fi
  ITEM_STATES["oh-my-zsh"]="$STATE_INSTALLED"
}

install_powerlevel10k() {
  local P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
  if [ ! -d "$P10K_DIR" ]; then
    info "Installing Powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    success "Powerlevel10k installed"
  else
    success "Powerlevel10k already installed"
  fi
  ITEM_STATES["powerlevel10k"]="$STATE_INSTALLED"
}

install_plugin() {
  local name="$1"
  local repo="$2"
  local dir="$ZSH_CUSTOM/plugins/$name"

  if [ ! -d "$dir" ]; then
    info "Installing plugin: $name"
    git clone "$repo" "$dir"
    success "$name installed"
  else
    success "$name already installed"
  fi
  ITEM_STATES["$name"]="$STATE_INSTALLED"
}

install_zsh_autosuggestions() {
  install_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions.git"
}

install_zsh_syntax_highlighting() {
  install_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
}

install_tmux() {
  if ! command -v tmux >/dev/null; then
    info "Installing tmux"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install tmux
        success "tmux installed"
      else
        error "Homebrew required but not available"
        ITEM_STATES["tmux"]="$STATE_FAILED"
        return 1
      fi
    else
      error "tmux installation requires manual intervention on Linux"
      warn "Please install manually: sudo apt install tmux"
      ITEM_STATES["tmux"]="$STATE_FAILED"
      return 1
    fi
  else
    success "tmux already installed"
  fi
  ITEM_STATES["tmux"]="$STATE_INSTALLED"
}

install_tmux_conf() {
  # Backup existing .tmux.conf
  if [ -f "$TMUX_CONF_TARGET" ]; then
    local BACKUP="$TMUX_CONF_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
    info "Backing up existing .tmux.conf → $BACKUP"
    cp "$TMUX_CONF_TARGET" "$BACKUP"
    success "Backup created"
  fi

  if [ ! -f "$TMUX_CONF_SOURCE" ]; then
    error "tmux.conf file not found in repository"
    ITEM_STATES["tmux-conf"]="$STATE_FAILED"
    return 1
  fi

  info "Installing new .tmux.conf"
  cp "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"
  success ".tmux.conf installed"
  ITEM_STATES["tmux-conf"]="$STATE_INSTALLED"
}

install_brew_package() {
  local package="$1"
  local cmd="${2:-$package}"
  
  if ! command -v "$cmd" >/dev/null; then
    info "Installing $package"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install "$package"
        success "$package installed"
      else
        error "Homebrew required but not available for $package"
        ITEM_STATES["$package"]="$STATE_FAILED"
        return 1
      fi
    else
      error "$package installation requires manual intervention on Linux"
      warn "Please install manually: sudo apt install $package"
      ITEM_STATES["$package"]="$STATE_FAILED"
      return 1
    fi
  else
    success "$package already installed"
  fi
  ITEM_STATES["$package"]="$STATE_INSTALLED"
}

install_pip_package() {
  local package="$1"
  local cmd="${2:-$package}"
  
  if ! command -v "$cmd" >/dev/null; then
    info "Installing $package"
    if command -v pip3 >/dev/null; then
      pip3 install "$package"
      success "$package installed"
    elif command -v pip >/dev/null; then
      pip install "$package"
      success "$package installed"
    else
      error "pip/pip3 required but not available for $package"
      warn "Please install manually: pip3 install $package"
      ITEM_STATES["$package"]="$STATE_FAILED"
      return 1
    fi
  else
    success "$package already installed"
  fi
  ITEM_STATES["$package"]="$STATE_INSTALLED"
}

install_cowsay() {
  install_brew_package "cowsay"
}

install_lolcat() {
  install_brew_package "lolcat"
}

install_fzf() {
  install_brew_package "fzf"
}

install_tree() {
  install_brew_package "tree"
}

install_neofetch() {
  install_brew_package "neofetch"
}

install_ffmpeg() {
  install_brew_package "ffmpeg"
}

install_cmatrix() {
  install_brew_package "cmatrix"
}

install_pygments() {
  install_pip_package "pygments" "pygmentize"
}

install_speedtest_cli() {
  if ! command -v speedtest-cli >/dev/null && ! command -v speedtest >/dev/null; then
    info "Installing speedtest-cli"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install speedtest-cli
        success "speedtest-cli installed"
      elif command -v pip3 >/dev/null; then
        pip3 install speedtest-cli
        success "speedtest-cli installed"
      elif command -v pip >/dev/null; then
        pip install speedtest-cli
        success "speedtest-cli installed"
      else
        error "No installer available for speedtest-cli"
        ITEM_STATES["speedtest-cli"]="$STATE_FAILED"
        return 1
      fi
    else
      if command -v pip3 >/dev/null; then
        pip3 install speedtest-cli
        success "speedtest-cli installed"
      elif command -v pip >/dev/null; then
        pip install speedtest-cli
        success "speedtest-cli installed"
      else
        error "pip/pip3 required but not available for speedtest-cli"
        ITEM_STATES["speedtest-cli"]="$STATE_FAILED"
        return 1
      fi
    fi
  else
    success "speedtest-cli already installed"
  fi
  ITEM_STATES["speedtest-cli"]="$STATE_INSTALLED"
}

# -------------------------
# Item Definitions
# -------------------------
define_items() {
  # Format: ITEM_DEPENDENCIES["item"]="dep1 dep2"
  # Format: ITEM_METADATA["item"]="description|required|install_func"
  # Note: "required" means auto-installed without prompt, "optional" means user is prompted
  
  # Required items (no dependencies, always installed)
  ITEM_DEPENDENCIES["oh-my-zsh"]=""
  ITEM_METADATA["oh-my-zsh"]="Oh My Zsh framework|required|install_oh_my_zsh"
  
  # Homebrew (required on macOS only)
  if [ "$OS_TYPE" = "macos" ]; then
    ITEM_DEPENDENCIES["homebrew"]=""
    ITEM_METADATA["homebrew"]="Homebrew package manager|required|install_homebrew"
  fi
  
  # Items dependent on oh-my-zsh
  ITEM_DEPENDENCIES["powerlevel10k"]="oh-my-zsh"
  ITEM_METADATA["powerlevel10k"]="Powerlevel10k theme|optional|install_powerlevel10k"
  
  ITEM_DEPENDENCIES["zsh-autosuggestions"]="oh-my-zsh"
  ITEM_METADATA["zsh-autosuggestions"]="zsh-autosuggestions plugin|optional|install_zsh_autosuggestions"
  
  ITEM_DEPENDENCIES["zsh-syntax-highlighting"]="oh-my-zsh"
  ITEM_METADATA["zsh-syntax-highlighting"]="zsh-syntax-highlighting plugin|optional|install_zsh_syntax_highlighting"
  
  # Items dependent on homebrew (macOS only)
  if [ "$OS_TYPE" = "macos" ]; then
    ITEM_DEPENDENCIES["cowsay"]="homebrew"
    ITEM_METADATA["cowsay"]="cowsay (fun ASCII art)|optional|install_cowsay"
    
    ITEM_DEPENDENCIES["lolcat"]="homebrew"
    ITEM_METADATA["lolcat"]="lolcat (rainbow text)|optional|install_lolcat"
  fi
  
  # Items that can use homebrew on macOS or manual install on Linux
  ITEM_DEPENDENCIES["tmux"]=""
  ITEM_METADATA["tmux"]="tmux terminal multiplexer|optional|install_tmux"
  
  ITEM_DEPENDENCIES["tmux-conf"]="tmux"
  ITEM_METADATA["tmux-conf"]="tmux configuration file|optional|install_tmux_conf"
  
  ITEM_DEPENDENCIES["fzf"]=""
  ITEM_METADATA["fzf"]="fzf fuzzy finder|optional|install_fzf"
  
  ITEM_DEPENDENCIES["tree"]=""
  ITEM_METADATA["tree"]="tree directory visualizer|optional|install_tree"
  
  ITEM_DEPENDENCIES["neofetch"]=""
  ITEM_METADATA["neofetch"]="neofetch system info|optional|install_neofetch"
  
  ITEM_DEPENDENCIES["ffmpeg"]=""
  ITEM_METADATA["ffmpeg"]="ffmpeg video processor|optional|install_ffmpeg"
  
  ITEM_DEPENDENCIES["cmatrix"]=""
  ITEM_METADATA["cmatrix"]="cmatrix matrix effect|optional|install_cmatrix"
  
  ITEM_DEPENDENCIES["pygments"]=""
  ITEM_METADATA["pygments"]="pygments syntax highlighter|optional|install_pygments"
  
  ITEM_DEPENDENCIES["speedtest-cli"]=""
  ITEM_METADATA["speedtest-cli"]="speedtest-cli speed test|optional|install_speedtest_cli"
}

# -------------------------
# Installation Engine
# -------------------------

# Process a single item
process_item() {
  local item="$1"
  local metadata="${ITEM_METADATA[$item]:-}"
  
  if [ -z "$metadata" ]; then
    warn "Item '$item' has no metadata, skipping"
    return 0
  fi
  
  local description="${metadata%%|*}"
  local required="${metadata#*|}"
  required="${required%%|*}"
  local install_func="${metadata##*|}"
  
  # Skip if already processed
  local current_state="${ITEM_STATES[$item]:-$STATE_PENDING}"
  if [ "$current_state" != "$STATE_PENDING" ]; then
    return 0
  fi
  
  # Validate dependencies
  if ! validate_dependencies "$item"; then
    return 1
  fi
  
  # Ask user for optional items only
  if [ "$required" != "required" ]; then
    if ! ask_yes_no "Install $item? ($description)"; then
      ITEM_STATES["$item"]="$STATE_SKIPPED"
      mark_blocked_cascade "$item" "User skipped installation"
      return 0
    fi
  fi
  
  # Execute installation
  local deps="${ITEM_DEPENDENCIES[$item]:-none}"
  if [ "$deps" = "none" ] || [ -z "$deps" ]; then
    depinfo "Installing $item (no dependencies)"
  else
    depinfo "Installing $item (depends on: $deps)"
  fi
  
  if "$install_func"; then
    success "$item installation completed"
    return 0
  else
    error "$item installation failed"
    mark_blocked_cascade "$item" "Installation failed"
    return 1
  fi
}

# Main installation loop
run_installation() {
  info "Starting dependency-driven installation"
  echo
  
  # Define all items
  define_items
  
  # Get installation order via topological sort
  info "Resolving dependency order..."
  readarray -t install_order < <(topological_sort)
  
  if [ ${#install_order[@]} -eq 0 ]; then
    error "No items to install"
    exit 1
  fi
  
  depinfo "Installation order: ${install_order[*]}"
  echo
  
  # Process items in topological order
  local installed_count=0
  local skipped_count=0
  local blocked_count=0
  local failed_count=0
  
  for item in "${install_order[@]}"; do
    process_item "$item"
    local state="${ITEM_STATES[$item]:-$STATE_PENDING}"
    case "$state" in
      "$STATE_INSTALLED") ((installed_count++)) ;;
      "$STATE_SKIPPED") ((skipped_count++)) ;;
      "$STATE_BLOCKED") ((blocked_count++)) ;;
      "$STATE_FAILED") ((failed_count++)) ;;
    esac
  done
  
  echo
  info "Installation summary:"
  success "  Installed: $installed_count"
  if [ $skipped_count -gt 0 ]; then
    warn "  Skipped: $skipped_count"
  fi
  if [ $blocked_count -gt 0 ]; then
    error "  Blocked: $blocked_count"
    echo
    warn "Blocked items (due to missing dependencies):"
    for item in "${!BLOCKED_REASONS[@]}"; do
      local reason="${BLOCKED_REASONS[$item]}"
      error "  - $item: $reason"
    done
  fi
  if [ $failed_count -gt 0 ]; then
    error "  Failed: $failed_count"
  fi
  echo
}

# -------------------------
# Post-Installation Tasks
# -------------------------
post_install() {
  # Backup and install .zshrc
  if [ -f "$ZSHRC_TARGET" ]; then
    local BACKUP="$ZSHRC_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
    info "Backing up existing .zshrc → $BACKUP"
    cp "$ZSHRC_TARGET" "$BACKUP"
    success "Backup created"
  fi

  if [ ! -f "$ZSHRC_SOURCE" ]; then
    error "zshrc file not found in repository"
    exit 1
  fi

  info "Installing new .zshrc"
  cp "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
  success ".zshrc installed"

  # Create directories
  mkdir -p "$HOME/.zsh/cache" "$HOME/.trash" "$HOME/notes"
  success "Required directories created"

  # Fonts reminder
  if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    warn "Powerlevel10k requires a Nerd Font"
    warn "Install one from: https://www.nerdfonts.com/"
  fi

  # Final instructions
  echo
  success "Setup complete 🎉"
  echo
  info "Next steps:"
  echo "  1) Restart your terminal OR run: source ~/.zshrc"
  if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "  2) Run: p10k configure"
    echo "  3) (Optional) Change default shell:"
  else
    echo "  2) (Optional) Change default shell:"
  fi
  echo "     chsh -s $(command -v zsh)"
  echo
}

# -------------------------
# Main
# -------------------------
main() {
  run_installation
  post_install
}

main "$@"