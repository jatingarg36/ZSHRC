#!/usr/bin/env bash
set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$BASE_DIR/lib/core.sh"
source "$BASE_DIR/lib/registry.sh"
source "$BASE_DIR/lib/dependency.sh"
source "$BASE_DIR/lib/menu.sh"
source "$BASE_DIR/lib/graph.sh"
source "$BASE_DIR/lib/explain.sh"

for f in "$BASE_DIR/modules/"*.sh; do source "$f"; done

TARGETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)
      for m in "${!MODULE_DEPS[@]}"; do
        echo "$m"
      done
      exit 0
      ;;
    --graph)
      print_full_graph
      exit 0
      ;;
    --explain)
      shift
      explain_module "$1"
      exit 0
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --yes|-y)
      AUTO_YES=true
      shift
      ;;
    --set-shell)
      TARGETS+=("set-default-shell")
      shift
      ;;
    *)
      TARGETS+=("$1")
      shift
      ;;

  esac
done

if (( ${#TARGETS[@]} == 0 )); then
  if $AUTO_YES; then
    # Non-interactive: install everything
    TARGETS=("${!MODULE_DEPS[@]}")
  else
    # Interactive selection
    select_modules_interactively
    TARGETS=("${SELECTED_MODULES[@]}")
  fi
fi

for m in "${TARGETS[@]}"; do run_module "$m"; done

echo
success "Setup completed"