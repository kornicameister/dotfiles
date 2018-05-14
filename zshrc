# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/kornicameister/.oh-my-zsh

ZSH_THEME="amuse"

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

export UPDATE_ZSH_DAYS=1

plugins=(
  git
  dotenv
  httpie
  git-prompt
  git-extras
  nvm
  zsh_reload
)

[ -f $ZSH/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export MANPATH="/usr/local/man:$MANPATH"
export EDITOR="vim"

alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"
