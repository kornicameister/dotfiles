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
