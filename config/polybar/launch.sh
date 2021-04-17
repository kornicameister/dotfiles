#!/usr/bin/env bash

DIR="${XDG_CONFIG_HOME}/polybar"

# kill
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# wait for X
while ! xset q &>/dev/null; do sleep 1; done

# launch
monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)
top_log="/tmp/polybar_top.log"
bottom_log="/tmp/polybar_bottom.log"

echo "---" | tee -a "${top_log}" "${bottom_log}"

MONITORS="${monitors}" polybar top -r -c "${DIR}/config.ini" >>"${top_log}" 2>&1 &
MONITORS="${monitors}" polybar bottom -r -c "${DIR}/config.ini" >>"${bottom_log}" 2>&1 &
