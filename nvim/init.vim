if isdirectory($PYENV_ROOT.'/versions/neovim2')
  let g:python_host_prog = $PYENV_ROOT.'/versions/neovim2/bin/python'
endif
if isdirectory($PYENV_ROOT.'/versions/neovim3')
  let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'
endif

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath= &runtimepath
source ~/.vimrc

" workaround some broken plugins which set guicursor indiscriminately.
set guicursor=
autocmd OptionSet guicursor noautocmd set guicursor=

" colors
let g:terminal_color_0  = '#282828'
let g:terminal_color_1  = '#cc241d'
let g:terminal_color_2  = '#00ffff'
let g:terminal_color_3  = '#d79921'
let g:terminal_color_4  = '#458588'
let g:terminal_color_5  = '#b16286'
let g:terminal_color_6  = '#689d6a'
let g:terminal_color_7  = '#a89984'
let g:terminal_color_8  = '#928374'
let g:terminal_color_9  = '#fb4934'
let g:terminal_color_10 = '#00df5f'
let g:terminal_color_11 = '#fabd2f'
let g:terminal_color_12 = '#00afff'
let g:terminal_color_13 = '#d3869b'
let g:terminal_color_14 = '#8ec07c'
let g:terminal_color_15 = '#ebdbb2'

" complete opts
set completeopt-=menu
set completeopt+=menuone   " Show the completions UI even with only 1 item
set completeopt-=longest   " Don't insert the longest common text
set completeopt-=preview   " Hide the documentation preview window
set completeopt+=noinsert  " Don't insert text automatically
set completeopt-=noselect  " Highlight the first completion automatically
