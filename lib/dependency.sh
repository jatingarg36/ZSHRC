#!/usr/bin/env zsh

typeset -A INSTALLED SKIPPED FAILED

run_module() {
  local name="$1"
  local deps="${MODULE_DEPS[$name]:-}"

  [[ ${INSTALLED[$name]+_} || ${SKIPPED[$name]+_} || ${FAILED[$name]+_} ]] && return

  for dep in ${=deps}; do
    run_module "$dep"
    if [[ ${SKIPPED[$dep]+_} || ${FAILED[$dep]+_} ]]; then
      warn "Skipping $name → dependency '$dep' unavailable"
      SKIPPED[$name]=1
      return
    fi
  done

  if ! ask_yes_no "Install $name?"; then
    SKIPPED[$name]=1
    return
  fi

  if eval "${MODULE_CHECK[$name]}"; then
    success "$name already installed"
    INSTALLED[$name]=1
    return
  fi

  if $DRY_RUN; then
    info "[dry-run] Would install $name"
    INSTALLED[$name]=1
    return
  fi

  info "Installing $name"
  if eval "${MODULE_INSTALL[$name]}"; then
    INSTALLED[$name]=1
    success "$name installed"
  else
    FAILED[$name]=1
    error "$name failed"
  fi
}