#!/usr/bin/env bash

# Make vim the default editor.
export EDITOR='vim';

# Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
export PYTHONIOENCODING='UTF-8';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
export HISTCONTROL='ignoreboth'; # Omit duplicates and commands that
                                 # begin with a space from history.

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Setting for bash-git-prompt
export GIT_PROMPT_ONLY_IN_REPO=0
export GIT_PROMPT_SHOW_UPSTREAM=1
export GIT_PROMPT_THEME=Single_line_Solarized_Lamda

# fzf settings
command -v fzf >/dev/null 2>&1 && export FZF_DEFAULT_OPTS="--height 60% --reverse --border"
