#!/usr/bin/env bash

select_modules_interactively() {
  info "Select modules (space-separated numbers):"
  local keys=("${!MODULE_DEPS[@]}")

  for i in "${!keys[@]}"; do
    printf " [%d] %s (deps: %s)\n" "$((i+1))" "${keys[$i]}" "${MODULE_DEPS[${keys[$i]}]:-none}"
  done

  echo
  read -p "Choice: " -a choices

  SELECTED_MODULES=()
  for c in "${choices[@]}"; do
    SELECTED_MODULES+=("${keys[$((c-1))]}")
  done
}