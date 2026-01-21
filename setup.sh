#!/usr/bin/env zsh
set -Eeuo pipefail

# Resolve the real path of the script, handling symlinks
SOURCE="${(%):-%N}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
BASE_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

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
      for m in "${(@k)MODULE_DEPS}"; do
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
    --help|-h)
      echo "Usage: ./setup.sh [options] [module...]"
      echo
      echo "Options:"
      echo "  --list           List available modules"
      echo "  --graph          Show dependency graph"
      echo "  --explain <mod>  Explain a module"
      echo "  --dry-run        Simulate installation"
      echo "  --yes, -y        Auto-confirm prompts"
      echo "  --set-shell      Install set-default-shell module"
      echo "  --help, -h       Show this help message"
      exit 0
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
    TARGETS=("${(@k)MODULE_DEPS}")
  else
    # Interactive selection
    select_modules_interactively
    TARGETS=("${SELECTED_MODULES[@]}")
  fi
fi

for m in "${TARGETS[@]}"; do run_module "$m"; done

echo
success "Setup completed"