#!/usr/bin/env bash

register "brew" "zsh" \
  "command -v brew >/dev/null" \
  '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' \
  "Homebrew package manager (macOS)"