#!/usr/bin/env bash

register "set-default-shell" "zsh" \
  '[ "$SHELL" = "$(command -v zsh)" ]' \
  '
  if $IS_CI; then
    warn "CI environment detected — skipping shell change"
    exit 0
  fi

  ZSH_PATH="$(command -v zsh)"

  if ! grep -q "$ZSH_PATH" /etc/shells; then
    warn "$ZSH_PATH not found in /etc/shells"
    warn "Add it manually:"
    echo "  sudo sh -c \"echo $ZSH_PATH >> /etc/shells\""
    exit 1
  fi

  info "Changing default shell to zsh"
  chsh -s "$ZSH_PATH"
  success "Default shell set to zsh"
  ' \
  "Sets zsh as the default login shell (skipped in CI)"