#!/usr/bin/env bash

# Fancy git commit browser

if ! command -v git >/dev/null 2>&1; then
    echo "git is required to run fshow"
    exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf is required to run fshow"
    exit 1
fi

git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --height 95% --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --header "Press CTRL-S to toggle sort" \
    --preview "echo {} | grep -o '[a-f0-9]\\{7\\}' | head -1 |
    xargs -I % sh -c 'git show --color=always % | head -200 '" \
    --bind "enter:execute:echo {} | grep -o '[a-f0-9]\\{7\\}' | head -1 |
    xargs -I % sh -c 'vim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
