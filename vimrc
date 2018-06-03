" Copyright 2018 @ kornicameister

if &compatible
    set nocompatible
endif

if has('vim_starting')
    call s:source_file('init.vim')
    if has('nvim')
        " Neovim settings
        call s:source_file('neovim.vim')
    elseif ! has('gui_running') && ! has('win32') && ! has('win64')
        " Linux terminal settings
        call s:source_file('terminal.vim')
    endif
endif

source ~/.vim/plugins.vim
source ~/.vim/editor.vim
source ~/.vim/session.vim
source ~/.vim/filetype.vim
