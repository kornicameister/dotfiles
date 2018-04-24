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
source ~/.vim/k/plugins/python.vim
source ~/.vim/k/plugins/folding.vim
source ~/.vim/k/plugins/rainbow.vim
source ~/.vim/k/plugins/json.vim
source ~/.vim/k/plugins/ctrlp.vim

Plug 'wakatime/vim-wakatime'
Plug 'ConradIrwin/vim-bracketed-paste'

" plugins

call plug#end()

" load pluggins settings at this point, now that all plugins are in
source ~/.vim/k/plugins/settings.vim
