" Copyright 2017 @ kornicameiter

let os = substitute(system('uname'), "\n", "", "")

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

source ~/.vim/plugins/whitespace.vim
source ~/.vim/plugins/airline.vim
source ~/.vim/plugins/ale.vim
source ~/.vim/plugins/git.vim
source ~/.vim/plugins/theming.vim
source ~/.vim/plugins/fzf.vim
source ~/.vim/plugins/javascript.vim
source ~/.vim/plugins/commit.vim
source ~/.vim/plugins/elm.vim
source ~/.vim/plugins/python.vim
source ~/.vim/plugins/folding.vim
source ~/.vim/plugins/rainbow.vim
source ~/.vim/plugins/json.vim
source ~/.vim/plugins/ctrlp.vim
source ~/.vim/plugins/md.vim
source ~/.vim/plugins/deoplete.vim
source ~/.vim/plugins/docker.vim
source ~/.vim/plugins/startify.vim

Plug 'wakatime/vim-wakatime'
Plug 'ConradIrwin/vim-bracketed-paste'

" plugins

call plug#end()
