#!/usr/bin/env zsh

explain_module() {
  local name="$1"

  [[ -z "${MODULE_DEPS[$name]+_}" ]] && { error "Unknown module"; exit 1; }

  echo
  info "Module: $name"
  echo "Description : ${MODULE_DESC[$name]:-N/A}"
  echo "Depends on  : ${MODULE_DEPS[$name]:-none}"

  local used_by=()
  for m in "${(@k)MODULE_DEPS}"; do
    [[ " ${MODULE_DEPS[$m]} " =~ " $name " ]] && used_by+=("$m")
  done

  echo "Required by : ${used_by[*]:-none}"
  echo
}