#!/usr/bin/env bash

register "tree" "brew" \
  "command -v tree >/dev/null" \
  "brew install tree" \
  "Directory tree viewer"

register "neofetch" "brew" \
  "command -v neofetch >/dev/null" \
  "brew install neofetch" \
  "System info display"

register "ffmpeg" "brew" \
  "command -v ffmpeg >/dev/null" \
  "brew install ffmpeg" \
  "Media processing toolkit"