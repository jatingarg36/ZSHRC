#!/usr/bin/env zsh

select_modules_interactively() {
  info "Select modules (space-separated numbers):"
  local keys=("${(@k)MODULE_DEPS}")

  # Zsh arrays are 1-indexed.
  for i in {1..$#keys}; do
    printf " [%d] %s (deps: %s)\n" "$i" "${keys[$i]}" "${MODULE_DEPS[${keys[$i]}]:-none}"
  done

  echo
  read -A "choices?Choice: "

  SELECTED_MODULES=()
  for c in "${choices[@]}"; do
    SELECTED_MODULES+=("${keys[$c]}")
  done
}