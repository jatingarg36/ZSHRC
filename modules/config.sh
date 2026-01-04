#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ZSHRC_SOURCE="$SCRIPT_DIR/zshrc"
TMUX_CONF_SOURCE="$SCRIPT_DIR/tmux.conf"

register "config" "zsh tmux ohmyzsh" \
  'false' \
  '
  ts="$(date +%Y%m%d_%H%M%S)"

  # ---- zshrc ----
  if [[ -f "$ZSHRC_SOURCE" ]]; then
    if [[ -f "$HOME/.zshrc" ]]; then
      cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$ts"
      success "Backed up existing .zshrc"
    fi
    cp "$ZSHRC_SOURCE" "$HOME/.zshrc"
    success ".zshrc updated"
  else
    warn "zshrc not found in repository"
  fi

  # ---- tmux.conf ----
  if [[ -f "$TMUX_CONF_SOURCE" ]]; then
    if [[ -f "$HOME/.tmux.conf" ]]; then
      cp "$HOME/.tmux.conf" "$HOME/.tmux.conf.backup.$ts"
      success "Backed up existing .tmux.conf"
    fi
    cp "$TMUX_CONF_SOURCE" "$HOME/.tmux.conf"
    success ".tmux.conf updated"
  else
    warn "tmux.conf not found in repository"
  fi

  # ---- directories ----
  mkdir -p "$HOME/.zsh/cache" "$HOME/.trash" "$HOME/notes"
  success "Required directories ensured"
  ' \
  "Installs or updates zsh and tmux configuration files"