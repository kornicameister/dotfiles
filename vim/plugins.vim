" Copyright 2017 @ kornicameiter

let os = substitute(system('uname'), "\n", "", "")

call plug#begin('~/.vim/plugged')

source ~/.vim/k/plugins/git.vim
source ~/.vim/k/plugins/theming.vim
source ~/.vim/k/plugins/code_assistance.vim
source ~/.vim/k/plugins/react.vim

Plug 'chase/vim-ansible-yaml'
Plug 'wakatime/vim-wakatime'

Plug 'ConradIrwin/vim-bracketed-paste'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'jmcantrell/vim-virtualenv'
Plug 'luochen1990/rainbow'
Plug 'nvie/vim-flake8'
Plug 'lervag/vimtex'

Plug 'honza/vim-snippets'
Plug 'glench/vim-jinja2-syntax'

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'

if os == "Linux"
  " following plugins works only for Linux
  Plug 'SirVer/ultisnips'
endif

Plug 'tmhedberg/SimpylFold'
Plug 'hashivim/vim-vagrant'

Plug 'ervandew/supertab'    "supertab

" plugins

call plug#end()

" load pluggins settings at this point, now that all plugins are in
source ~/.vim/k/plugins/settings.vim
