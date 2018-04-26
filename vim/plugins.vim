" Copyright 2017 @ kornicameiter

let os = substitute(system('uname'), "\n", "", "")

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

source ~/.vim/k/plugins/whitespace.vim
source ~/.vim/k/plugins/airline.vim
source ~/.vim/k/plugins/ale.vim
source ~/.vim/k/plugins/git.vim
source ~/.vim/k/plugins/theming.vim
source ~/.vim/k/plugins/fzf.vim
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
source ~/.vim/k/plugins/md.vim

Plug 'wakatime/vim-wakatime'
Plug 'ConradIrwin/vim-bracketed-paste'

" plugins

call plug#end()
