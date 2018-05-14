# If you come from bash you might have to change your $PATH.

export ZDOTDIR=$HOME

[ -f "${ZDOTDIR}/.zprezto/init.zsh" ] && source "${ZDOTDIR}/.zprezto/init.zsh"
[ -f "${ZDOTDIR}/.fzf.zsh" ] && source "${ZDOTDIR}/.fzf.zsh"

export EDITOR="vim"
export VISUAL="${EDITOR}"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
