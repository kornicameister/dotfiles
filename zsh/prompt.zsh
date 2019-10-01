#/usr/bin/env zsh

# tweak colors
zstyle :prompt:pure:path color white
zstyle :prompt:pure:prompt:success color green
zstyle :prompt:pure:prompt:error color red

# tweak symbols
PURE_PROMPT_SYMBOL='>>'
PURE_GIT_UP_ARROW='ﰵ'
PURE_GIT_DOWN_ARROW=''

# made some tweaks to be awasome
RPROMPT="${RPROMPT:=''}"

right_prompt() {
    RPROMPT='%F{white}%*'
}

add-zsh-hook precmd right_prompt
