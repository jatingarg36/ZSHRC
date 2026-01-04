#!/usr/bin/env bash

register "p10k" "ohmyzsh" \
  '[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]' \
  'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"' \
  "Powerlevel10k theme"