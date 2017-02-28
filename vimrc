" autocommand, whenever save file ~/.vimrc, it gets automatically sourced
:au! BufWritePost $MYVIMRC source $MYVIMRC

""" editior settings
set smartindent
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" make whitespaces, tabs visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" enable filetypes plugins
filetype plugin on
""" editor settings

" determine OS for come conditional installations
let os = substitute(system('uname'), "\n", "", "")

call plug#begin('~/.vim/plugged')

" plugins
Plug 'tpope/vim-fugitive'
Plug 'chase/vim-ansible-yaml'
Plug 'wakatime/vim-wakatime'

Plug 'jnurmine/Zenburn'
Plug 'altercation/vim-colors-solarized'

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

" plugins

call plug#end()

" vim colors solarized settings
syntax on
if has('gui_running')
    colorscheme zenburn
    set background=dark
else
    colorscheme solarized
    set background=dark
endif

" tabs keybindings
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>

" vim-ansible-yaml
let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_options = {'documentation_mapping': '<C-K>'} "ctrl-k for docs

" vim-arline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'simple'
set laststatus=2

" rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" splitting windows settings
set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99

nnoremap <space> za

" ensure utf-8
set encoding=utf-8

" file tree
let NERDTreeIgnore=['\.pyc$', '\~$']
let g:NERDTreeShowIgnoredStatus = 0
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" set vertical line marking end-of-line
set colorcolumn=79
match ErrorMsg '\%>80v.\+'

