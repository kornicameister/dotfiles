#!/usr/bin/env bash

# contains configuration for https://github.com/sjl/t
export T_DIR=$HOME/.cache/tasks

[ ! -d "${T_DIR}" ] && mkdir -p "${T_DIR}"

alias t='t --task-dir $T_DIR --list tasks'
alias td='t --task-dir $T_DIR --list technical_debt'
