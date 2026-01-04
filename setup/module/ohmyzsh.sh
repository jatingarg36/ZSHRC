#!/usr/bin/env bash

register "ohmyzsh" "zsh" \
  '[ -d "$HOME/.oh-my-zsh" ]' \
  'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' \
  "Zsh framework"