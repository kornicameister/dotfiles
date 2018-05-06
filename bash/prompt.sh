#!/usr/bin/env bash

#Regular text color
BLACK='\[\e[0;30m\]'
#Bold text color
BBLACK='\[\e[1;30m\]'
#background color
BGBLACK='\[\e[40m\]'
RED='\[\e[0;31m\]'
BRED='\[\e[1;31m\]'
BGRED='\[\e[41m\]'
GREEN='\[\e[0;32m\]'
BGREEN='\[\e[1;32m\]'
BGGREEN='\[\e[1;32m\]'
YELLOW='\[\e[0;33m\]'
BYELLOW='\[\e[1;33m\]'
BGYELLOW='\[\e[1;33m\]'
BLUE='\[\e[0;34m\]'
BBLUE='\[\e[1;34m\]'
BGBLUE='\[\e[1;34m\]'
MAGENTA='\[\e[0;35m\]'
BMAGENTA='\[\e[1;35m\]'
BGMAGENTA='\[\e[1;35m\]'
CYAN='\[\e[0;36m\]'
BCYAN='\[\e[1;36m\]'
BGCYAN='\[\e[1;36m\]'
WHITE='\[\e[0;37m\]'
BWHITE='\[\e[1;37m\]'
BGWHITE='\[\e[1;37m\]'


smile_prompt()
{
    if [ "$?" -eq "0" ]
    then
        #smiley
        SC="${GREEN}😋"
    else
        #frowney
        SC="${RED}☹i"
    fi

    if [ $UID -eq 0 ]
    then
        #root user color
        UC="${BRED}"
    else
        #normal user color
        UC="${BMAGENTA}"
    fi

    #directory color
    DC="${BBLUE}"

    #regular color
    RC="${BMAGENTA}"

    #default color
    DF='\[\e[0m\]'

    PS1="[${UC}☠ ${DC}\w${DF}]${SC}${DF} > "
}

PROMPT_COMMAND=smile_prompt
