set -x PYENV_ROOT $HOME/.pyenv
set -x PATH $PYENV_ROOT/bin $PATH
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

if status is-login
  . (pyenv init --path | psub)
end
if status is-interactive
  . (pyenv init - | psub)
  . (pyenv virtualenv-init - | psub)
end

set fzf_preview_dir_cmd exa --all --color=always

# aliases
alias l='exa --sort=changed --icons -la --git --git-ignore --ignore-glob=".git|__pycache__"'
alias ls='exa --icons'
alias la='exa --group-directories-first --icons -la'
alias ll='exa --group-directories-first --icons -la --color-scale --time-style=long-iso --git --git-ignore --ignore-glob=".git|__pycache__"'
alias tree='exa --group-directories-first -T --icons --level=2'
