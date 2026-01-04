#!/usr/bin/env bash
set -Eeuo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}ℹ${NC} $*"; }
success() { echo -e "${GREEN}✔${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠${NC} $*"; }
error()   { echo -e "${RED}✖${NC} $*"; }

AUTO_YES=false
DRY_RUN=false

ask_yes_no() {
  local prompt="$1"
  if $AUTO_YES; then
    info "$prompt → auto-yes"
    return 0
  fi
  read -p "$(echo -e "${BLUE}?${NC} $prompt [y/N]: ")" r
  [[ "$r" =~ ^[Yy]$ ]]
}

OS_TYPE="$(uname -s)"
case "$OS_TYPE" in
  Darwin) OS_TYPE="macos" ;;
  Linux)  OS_TYPE="linux" ;;
  *) error "Unsupported OS"; exit 1 ;;
esac