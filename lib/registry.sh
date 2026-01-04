#!/usr/bin/env bash

declare -A MODULE_DEPS MODULE_CHECK MODULE_INSTALL MODULE_DESC

register() {
  MODULE_DEPS[$1]="$2"
  MODULE_CHECK[$1]="$3"
  MODULE_INSTALL[$1]="$4"
  MODULE_DESC[$1]="$5"
}