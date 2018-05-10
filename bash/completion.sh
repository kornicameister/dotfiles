#!/usr/bin/env bash
# all sorts of completion I use

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# kubectl, if installed
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion bash)
