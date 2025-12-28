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
# Install Powerlevel10k
# -------------------------
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  info "Installing Powerlevel10k"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  success "Powerlevel10k installed"
else
  success "Powerlevel10k already installed"
fi

# -------------------------
# Install Plugins
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

install_plugin "zsh-autosuggestions" \
  "https://github.com/zsh-users/zsh-autosuggestions.git"

install_plugin "zsh-syntax-highlighting" \
  "https://github.com/zsh-users/zsh-syntax-highlighting.git"

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
# Fonts reminder
# -------------------------
warn "Powerlevel10k requires a Nerd Font"
warn "Install one from: https://www.nerdfonts.com/"

# -------------------------
# Final instructions
# -------------------------
echo
success "Setup complete 🎉"
echo
info "Next steps:"
echo "  1) Restart your terminal OR run: source ~/.zshrc"
echo "  2) Run: p10k configure"
echo "  3) (Optional) Change default shell:"
echo "     chsh -s $(command -v zsh)"
echo