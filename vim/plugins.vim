" Copyright 2017 @ kornicameiter

let os = substitute(system('uname'), "\n", "", "")

call plug#begin('~/.vim/plugged')

source ~/.vim/k/plugins/airline.vim
source ~/.vim/k/plugins/ale.vim
source ~/.vim/k/plugins/git.vim
source ~/.vim/k/plugins/theming.vim
source ~/.vim/k/plugins/code_assistance.vim
source ~/.vim/k/plugins/javascript.vim
source ~/.vim/k/plugins/commit.vim
source ~/.vim/k/plugins/elm.vim
source ~/.vim/k/plugins/nerdtree.vim
source ~/.vim/k/plugins/you_complete_me.vim

Plug 'wakatime/vim-wakatime'

Plug 'ConradIrwin/vim-bracketed-paste'

Plug 'jmcantrell/vim-virtualenv', {'for': ['python']}
Plug 'luochen1990/rainbow'
Plug 'nvie/vim-flake8'
Plug 'lervag/vimtex'

Plug 'honza/vim-snippets'
Plug 'glench/vim-jinja2-syntax'

if os == "Linux"
  " following plugins works only for Linux
  Plug 'SirVer/ultisnips'
endif

Plug 'tmhedberg/SimpylFold'

" plugins

call plug#end()

" load pluggins settings at this point, now that all plugins are in
source ~/.vim/k/plugins/settings.vim
