#!/usr/bin/env bash
# ------------------------------------------------------------
# Enhanced Zsh Setup Script
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
NC='\033[0m'

# -------------------------
# Helpers
# -------------------------
info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✖${NC} $*"; }

trap 'error "Setup failed. Aborting."' ERR

# Ask user for yes/no confirmation
ask_yes_no() {
  local prompt="$1"
  local default="${2:-n}"  # Default to 'n' if not provided
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

# -------------------------
# Install Zsh (if missing)
# -------------------------
if ! command -v zsh >/dev/null; then
  warn "Zsh not found. Please install it manually:"
  if [ "$OS_TYPE" = "macos" ]; then
    echo "  brew install zsh"
  else
    echo "  sudo apt install zsh"
  fi
  exit 1
else
  success "Zsh found"
fi

# -------------------------
# Install Homebrew (macOS only)
# -------------------------
if [ "$OS_TYPE" = "macos" ]; then
  if ! command -v brew >/dev/null; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew installed"
  else
    success "Homebrew already installed"
  fi
fi

# -------------------------
# Install cowsay and lolcat (macOS only, optional)
# -------------------------
if [ "$OS_TYPE" = "macos" ] && command -v brew >/dev/null; then
  if ask_yes_no "Install cowsay? (fun ASCII art tool)"; then
    if ! command -v cowsay >/dev/null; then
      info "Installing cowsay"
      brew install cowsay
      success "cowsay installed"
    else
      success "cowsay already installed"
    fi
  fi

  if ask_yes_no "Install lolcat? (rainbow text effect)"; then
    if ! command -v lolcat >/dev/null; then
      info "Installing lolcat"
      brew install lolcat
      success "lolcat installed"
    else
      success "lolcat already installed"
    fi
  fi
fi

# -------------------------
# Install tmux (optional)
# -------------------------
if ask_yes_no "Install tmux? (terminal multiplexer)"; then
  if ! command -v tmux >/dev/null; then
    info "Installing tmux"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install tmux
        success "tmux installed"
      else
        warn "Homebrew not found. Please install tmux manually:"
        echo "  brew install tmux"
      fi
    else
      warn "Please install tmux manually:"
      echo "  sudo apt install tmux"
    fi
  else
    success "tmux already installed"
  fi

  # Install .tmux.conf if tmux is available
  if command -v tmux >/dev/null; then
    if ask_yes_no "Install .tmux.conf configuration file?"; then
      # Backup existing .tmux.conf
      if [ -f "$TMUX_CONF_TARGET" ]; then
        BACKUP="$TMUX_CONF_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
        info "Backing up existing .tmux.conf → $BACKUP"
        cp "$TMUX_CONF_TARGET" "$BACKUP"
        success "Backup created"
      fi

      # Install new .tmux.conf
      if [ ! -f "$TMUX_CONF_SOURCE" ]; then
        error "tmux.conf file not found in repository"
        exit 1
      fi

      info "Installing new .tmux.conf"
      cp "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"
      success ".tmux.conf installed"
    fi
  fi
fi

# -------------------------
# Install Oh My Zsh
# -------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh installed"
else
  success "Oh My Zsh already installed"
fi

# -------------------------
# Install Powerlevel10k (optional)
# -------------------------
if ask_yes_no "Install Powerlevel10k theme? (recommended for zshrc)"; then
  P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
  if [ ! -d "$P10K_DIR" ]; then
    info "Installing Powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    success "Powerlevel10k installed"
  else
    success "Powerlevel10k already installed"
  fi
fi

# -------------------------
# Install Plugins (optional)
# -------------------------
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
}

if ask_yes_no "Install zsh-autosuggestions plugin?"; then
  install_plugin "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions.git"
fi

if ask_yes_no "Install zsh-syntax-highlighting plugin?"; then
  install_plugin "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
fi

# -------------------------
# Install fzf (optional)
# -------------------------
if ask_yes_no "Install fzf? (fuzzy finder - used by fcd, fopen, openg functions)"; then
  if ! command -v fzf >/dev/null; then
    info "Installing fzf"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install fzf
        success "fzf installed"
      else
        warn "Homebrew not found. Please install fzf manually:"
        echo "  brew install fzf"
      fi
    else
      warn "Please install fzf manually:"
      echo "  sudo apt install fzf"
    fi
  else
    success "fzf already installed"
  fi
fi

# -------------------------
# Install tree (optional)
# -------------------------
if ask_yes_no "Install tree? (directory tree visualization)"; then
  if ! command -v tree >/dev/null; then
    info "Installing tree"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install tree
        success "tree installed"
      else
        warn "Homebrew not found. Please install tree manually:"
        echo "  brew install tree"
      fi
    else
      warn "Please install tree manually:"
      echo "  sudo apt install tree"
    fi
  else
    success "tree already installed"
  fi
fi

# -------------------------
# Install neofetch (optional)
# -------------------------
if ask_yes_no "Install neofetch? (system information display)"; then
  if ! command -v neofetch >/dev/null; then
    info "Installing neofetch"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install neofetch
        success "neofetch installed"
      else
        warn "Homebrew not found. Please install neofetch manually:"
        echo "  brew install neofetch"
      fi
    else
      warn "Please install neofetch manually:"
      echo "  sudo apt install neofetch"
    fi
  else
    success "neofetch already installed"
  fi
fi

# -------------------------
# Install ffmpeg (optional)
# -------------------------
if ask_yes_no "Install ffmpeg? (video/audio processing - used by vid2gif function)"; then
  if ! command -v ffmpeg >/dev/null; then
    info "Installing ffmpeg"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install ffmpeg
        success "ffmpeg installed"
      else
        warn "Homebrew not found. Please install ffmpeg manually:"
        echo "  brew install ffmpeg"
      fi
    else
      warn "Please install ffmpeg manually:"
      echo "  sudo apt install ffmpeg"
    fi
  else
    success "ffmpeg already installed"
  fi
fi

# -------------------------
# Install pygments (optional)
# -------------------------
if ask_yes_no "Install pygments? (Python syntax highlighter - used by ccat function)"; then
  if ! command -v pygmentize >/dev/null; then
    info "Installing pygments"
    if command -v pip3 >/dev/null; then
      pip3 install pygments
      success "pygments installed"
    elif command -v pip >/dev/null; then
      pip install pygments
      success "pygments installed"
    else
      warn "pip/pip3 not found. Please install pygments manually:"
      echo "  pip3 install pygments"
      echo "  or: pip install pygments"
    fi
  else
    success "pygments already installed"
  fi
fi

# -------------------------
# Install cmatrix (optional)
# -------------------------
if ask_yes_no "Install cmatrix? (Matrix effect - fun terminal animation)"; then
  if ! command -v cmatrix >/dev/null; then
    info "Installing cmatrix"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install cmatrix
        success "cmatrix installed"
      else
        warn "Homebrew not found. Please install cmatrix manually:"
        echo "  brew install cmatrix"
      fi
    else
      warn "Please install cmatrix manually:"
      echo "  sudo apt install cmatrix"
    fi
  else
    success "cmatrix already installed"
  fi
fi

# -------------------------
# Install speedtest-cli (optional)
# -------------------------
if ask_yes_no "Install speedtest-cli? (internet speed test tool)"; then
  if ! command -v speedtest-cli >/dev/null && ! command -v speedtest >/dev/null; then
    info "Installing speedtest-cli"
    if [ "$OS_TYPE" = "macos" ]; then
      if command -v brew >/dev/null; then
        brew install speedtest-cli
        success "speedtest-cli installed"
      else
        if command -v pip3 >/dev/null; then
          pip3 install speedtest-cli
          success "speedtest-cli installed"
        elif command -v pip >/dev/null; then
          pip install speedtest-cli
          success "speedtest-cli installed"
        else
          warn "Homebrew and pip not found. Please install speedtest-cli manually:"
          echo "  brew install speedtest-cli"
          echo "  or: pip3 install speedtest-cli"
        fi
      fi
    else
      if command -v pip3 >/dev/null; then
        pip3 install speedtest-cli
        success "speedtest-cli installed"
      elif command -v pip >/dev/null; then
        pip install speedtest-cli
        success "speedtest-cli installed"
      else
        warn "pip/pip3 not found. Please install speedtest-cli manually:"
        echo "  pip3 install speedtest-cli"
        echo "  or: sudo apt install speedtest-cli"
      fi
    fi
  else
    success "speedtest-cli already installed"
  fi
fi

# -------------------------
# Backup existing .zshrc
# -------------------------
if [ -f "$ZSHRC_TARGET" ]; then
  BACKUP="$ZSHRC_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
  info "Backing up existing .zshrc → $BACKUP"
  cp "$ZSHRC_TARGET" "$BACKUP"
  success "Backup created"
fi

# -------------------------
# Install new .zshrc
# -------------------------
if [ ! -f "$ZSHRC_SOURCE" ]; then
  error "zshrc file not found in repository"
  exit 1
fi

info "Installing new .zshrc"
cp "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
success ".zshrc installed"

# -------------------------
# Create directories
# -------------------------
mkdir -p "$HOME/.zsh/cache" "$HOME/.trash" "$HOME/notes"
success "Required directories created"

# -------------------------
# Fonts reminder (if Powerlevel10k is installed)
# -------------------------
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  warn "Powerlevel10k requires a Nerd Font"
  warn "Install one from: https://www.nerdfonts.com/"
fi

# -------------------------
# Final instructions
# -------------------------
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