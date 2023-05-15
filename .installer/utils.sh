#!/bin/bash

log_info() {
  local icon
  icon="[  ]${2:-""}"
  printf "\\r  \\033[00;20m${icon} %s\\n" "${1}"
}

log_notice() {
  local icon
  icon="[   ]${2:-""}"
  printf "\\r  \\033[00;20m${icon} %s\\n" "${1}"
}

log_warning() {
  local icon
  icon="[  ]${2:-""}"
  printf "\\r  \\033[00;20m${icon} %s\\n" "${1}"
}

log_done() {
  local icon
  icon="[  ]${2-""}"
  printf "\\r  \\033[00;20m${icon} %s\\n" "${1}"
}

log_die() {
  local icon
  icon="${2-""}[ 😱 ]"
  printf "\\r  \\033[00;20m${icon} %s\\n" "${1}"
  exit "${3:-1}"
}
