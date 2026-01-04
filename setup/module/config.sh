#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ZSHRC_SOURCE="$SCRIPT_DIR/zshrc"
TMUX_CONF_SOURCE="$SCRIPT_DIR/tmux.conf"

register "config" "zsh tmux ohmyzsh" \
  '[ -f "$HOME/.zshrc" -a -f "$HOME/.tmux.conf" ]' \
  '
  ts="$(date +%Y%m%d_%H%M%S)"

  # ---- zshrc ----
  if [[ -f "$ZSHRC_SOURCE" ]]; then
    [[ -f "$HOME/.zshrc" ]] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$ts"
    cp "$ZSHRC_SOURCE" "$HOME/.zshrc"
    success ".zshrc installed"
  else
    warn "zshrc not found in repo"
  fi

  # ---- tmux.conf ----
  if [[ -f "$TMUX_CONF_SOURCE" ]]; then
    [[ -f "$HOME/.tmux.conf" ]] && cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$ts"
    cp "$TMUX_CONF_SOURCE" "$HOME/.tmux.conf"
    success ".tmux.conf installed"
  else
    warn "tmux.conf not found in repo"
  fi

  # ---- directories ----
  mkdir -p "$HOME/.zsh/cache" "$HOME/.trash" "$HOME/notes"
  success "Required directories created"
  ' \
  "Installs zsh and tmux configuration files"