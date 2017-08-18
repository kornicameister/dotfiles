" Copyright 2017 kornicameister
"
set encoding=utf-8

set smartindent
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

set backspace=indent,eol,start
fixdel

" make whitespaces, tabs visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" enable filetypes plugins
filetype plugin on
""" editor settings

" vim theme settings
syntax on
if has('gui_running')
    colorscheme zenburn
    set background=dark
else
    colorscheme jellybeans
    set background=dark
endif

" tabs keybindings
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>

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

" transparent background always
hi Normal ctermbg=none
