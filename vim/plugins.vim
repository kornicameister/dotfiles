" Copyright 2017 @ kornicameiter

" Contains settings for all of the plugins

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
Plug 'luochen1990/rainbow'

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

" tags
Plug 'majutsushi/tagbar'                            " tagbar

" various
Plug 'wakatime/vim-wakatime'                        " track what I am doing when using vim
Plug 'mhinz/vim-startify'                           " nice start screen
Plug 'xolox/vim-notes', { 'for': ['notes'], 'on': 'Note' }        " taking notes in vim
Plug 'xolox/vim-misc', { 'for': ['notes'], 'on': 'Note' }
call plug#end()

" Plugin Customizations
" =====================
autocmd VimEnter * nested :call tagbar#autoopen(1)

" always color brackets
let g:rainbow_active = 1

" automatically fix whitespaces
autocmd BufEnter * FixWhitespace
autocmd BufWritePre * FixWhitespace

" airline plugin settings
let g:airline_theme = 'gruvbox'

let g:airline_powerline_fonts = 1
let g:airline_left_sep='›'          " Slightly fancier than '>'
let g:airline_right_sep='‹'         " Slightly fancier than '<'

let g:airline#extensions#ale#enabled = 1

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep=' '          " Slightly fancier than '>'
let g:airline#extensions#tabline#left_alt_sep=' '      " Slightly fancier than '<'

" commit msg - very nerdy
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

source ~/.vim/plugins/elm.vim
source ~/.vim/plugins/python.vim
source ~/.vim/plugins/deoplete.vim
