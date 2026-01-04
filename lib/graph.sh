#!/usr/bin/env bash

print_tree() {
  local node="$1"
  local prefix="$2"

  echo "${prefix}${node}"
  for dep in ${MODULE_DEPS[$node]}; do
    print_tree "$dep" "│   $prefix"
  done
}

print_full_graph() {
  info "Dependency Graph"
  echo

  local all_deps=()
  for m in "${!MODULE_DEPS[@]}"; do
    for d in ${MODULE_DEPS[$m]}; do all_deps+=("$d"); done
  done

  for m in "${!MODULE_DEPS[@]}"; do
    [[ ! " ${all_deps[*]} " =~ " $m " ]] && print_tree "$m" ""
  done
}