" Copyright 2017 @ kornicameiter

" Contains settings for all of the plugins

function! InstallVimPlug()
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    PlugInstall --sync | source $MYVIMRC
  endif
endfunction

" initialize vim plug
autocmd VimEnter * :call InstallVimPlug()

" define the plugins
call plug#begin('~/.vim/plugged')

" theme
Plug 'romainl/Apprentice'

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
Plug 'pbogut/deoplete-elm', { 'for': ['elm'] }
Plug 'Shougo/neco-vim', { 'for': ['vim', 'viminfo'] }
Plug 'mhartington/nvim-typescript', { 'for': ['typescript'], 'do': './install.sh'}

" asynchronous execution library
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }

" awesome commit message writing
Plug 'rhysd/committia.vim'
Plug 'scrooloose/nerdcommenter'

" general editor related plugins
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
Plug 'lambdalisue/vim-pyenv', {'for': ['python']}
Plug 'nvie/vim-flake8', {'for': ['python']}
Plug 'vim-scripts/indentpython.vim', {'for': ['python']}

" json
Plug 'elzr/vim-json', {'for': ['json']}

" markdown
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'MikeCoder/markdown-preview.vim', {'for': ['markdown']}

" tags
Plug 'majutsushi/tagbar'                            " tagbar

" various
Plug 'wakatime/vim-wakatime'                        " track what I am doing when using vim
Plug 'mhinz/vim-startify'                           " nice start screen
Plug 'xolox/vim-notes' | Plug 'xolox/vim-misc'      " notes taking in VIM
call plug#end()

" Plugin Customizations
" =====================
let g:tagbar_ctags_bin='ctags'
let g:tagbar_iconchars = ['►', '▼']
let g:tagbar_autoclose = 1
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:headings',
        \ 'l:links',
        \ 'i:images'
    \ ],
    \ "sort" : 0
\ }

" always color brackets
let g:rainbow_active = 1

" airline plugin settings
let g:airline_theme = 'jellybeans'

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

" elm plugin settings
let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 0

" ale settings
let g:ale_fix_on_save = 1                   " run on save
let g:ale_completion_enabled = 0            " do not mix up stuff with deoplete
let g:ale_sign_error = '✖'                  " error sign
let g:ale_sign_warning = '⚠'                " warning sign
let g:ale_fixers = ['trim_whitespace', 'remove_trailing_lines']

" deoplete settings
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
call deoplete#custom#option({
    \ 'auto_complete_delay': 200,
    \ 'smart_case': v:true,
    \ 'max_list': 50,
    \ })

" python
let python_highlight_all = 1
let g:pyenv#auto_create_ctags = 1
let g:pyenv#auto_assign_ctags = 1
