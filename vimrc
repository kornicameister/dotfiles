" first ever
set nocompatible

function! InstallVimPlug()
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        PlugInstall --sync | source $MYVIMRC
    endif
endfunction

function! SanitizePlugins()
    if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      PlugInstall --sync | q
      PlugClean | q
    endif
endfunction

function! InitVimPlug()
    :call InstallVimPlug()
    :call SanitizePlugins()
endfunction

" initialize vim plug
autocmd VimEnter * :call InitVimPlug()

" define the plugins
call plug#begin('~/.vim/plugged')

" theme
Plug 'morhetz/gruvbox'

" fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

" git plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'octref/rootignore'

" ale plugin
Plug 'w0rp/ale'

" deoplete
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim', { 'do': '!pip install --user --upgrade neovim' }
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
endif

" awesome commit message writing
Plug 'rhysd/committia.vim'
Plug 'scrooloose/nerdcommenter'

" general editor related plugins
Plug 'bronson/vim-trailing-whitespace'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'vim-airline/vim-airline'
Plug 'luochen1990/rainbow', {'do': ':RainbowToggleOn'}

" javascript & typescript plugins
Plug 'pangloss/vim-javascript', { 'for': ['typescript', 'javascript'] }
Plug 'mxw/vim-jsx', { 'for' : ['jsx'] }
Plug 'leafgarland/typescript-vim', { 'for' : ['typescript'] }
    Plug 'Quramy/tsuquyomi', { 'for' : ['typescript'] }

" docker
Plug 'ekalinin/Dockerfile.vim', { 'for': ['dockerfile'] }

" elm
Plug 'elmcast/elm-vim', {'for': ['elm']}

" python
Plug 'tmhedberg/SimpylFold', { 'for': ['python'] }
Plug 'jmcantrell/vim-virtualenv', {'for': ['python']}
Plug 'nvie/vim-flake8', {'for': ['python']}
Plug 'vim-scripts/indentpython.vim', {'for': ['python']}

" json
Plug 'elzr/vim-json', {'for': ['json']}

" markdown
Plug 'MikeCoder/markdown-preview.vim', {'for': ['markdown']}

" various
Plug 'wakatime/vim-wakatime'                        " track what I am doing when using vim
Plug 'mhinz/vim-startify'                           " nice start screen
Plug 'xolox/vim-notes', { 'for': ['notes'] }        " taking notes in vim
    Plug 'xolox/vim-misc', { 'for': ['notes'] }
call plug#end()

source ~/.vim/plugins.vim
source ~/.vim/editor.vim
source ~/.vim/session.vim
source ~/.vim/filetype.vim
