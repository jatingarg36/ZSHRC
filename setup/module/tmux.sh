#!/usr/bin/env bash

register "tmux" "brew" \
  "command -v tmux >/dev/null" \
  "brew install tmux" \
  "Terminal multiplexer"