# If you come from bash you might have to change your $PATH.

export ZDOTDIR=$HOME
export EDITOR="vim"
export VISUAL="${EDITOR}"

[ -f ~/.zgen/zgen.zsh ] && source ~/.zgen/zgen.zsh
if ! zgen saved; then
    zgen prezto
    zgen load sobolevn/wakatime-zsh-plugin
    zgen save
fi

[ -f ~/.zprezto/init.zsh ] && source ~/.zprezto/init.zsh
[ -f ~/.nvm.sh ] && source ~/.nvm.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

