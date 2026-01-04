#!/usr/bin/env bash

register "zsh-autosuggestions" "ohmyzsh" \
  '[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]' \
  'git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"' \
  "Zsh autosuggestions"

register "zsh-syntax-highlighting" "ohmyzsh" \
  '[ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]' \
  'git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"' \
  "Zsh syntax highlighting"