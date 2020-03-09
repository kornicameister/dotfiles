set nocompatible           " first ever

set fileencoding=utf-8     " utf-8 forever
set fileencodings=utf-8
set fileformats=unix       " only UNIX

set shell=/bin/zsh         " ZSH

let mapleader = ','        " early leader swap
let g:mapleader = ','      " just to be sure that everything is OK later

source ~/.vim/plugins.vim
source ~/.vim/editor.vim
source ~/.vim/filetype.vim
source ~/.vim/session.vim
