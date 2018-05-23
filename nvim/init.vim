let g:python_host_prog = '/home/kornicameister/dev/aps-confs/dependencies/pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/kornicameister/dev/aps-confs/dependencies/pyenv/versions/neovim3/bin/python'

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath= &runtimepath
source ~/.vimrc

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

set guicursor=
" workaround some broken plugins which set guicursor indiscriminately.
autocmd OptionSet guicursor noautocmd set guicursor=
