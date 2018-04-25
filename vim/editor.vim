" Copyright 2018 kornicameister

" leader
let mapleader=','

" save from typing :
nnoremap ; :

" general settings for editor
syntax on
set encoding=utf-8
set smartindent
set noerrorbells
set novisualbell
set timeoutlen=500

" searching stuff
set nohlsearch " no highlight search result
nnoremap <F3> :set hlsearch!<CR>
set incsearch " make it act more modern

" no temp or backup files
set noswapfile
set nobackup
set nowritebackup

" do not wrap lines
set nowrap

" tabs settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" indentation settings
set autoindent
set copyindent

" set title
set title

" make searching smart
set ignorecase
set smartcase

" Make the keyboard fast
set ttyfast
set timeout timeoutlen=1000 ttimeoutlen=50

" always safe on focus lost
au FocusLost * :wa

" backspace fix
set backspace=indent,eol,start
fixdel

" Show linenumbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set ruler

" make whitespaces, tabs visible
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
highlight BadWhitespace ctermbg=red guibg=red
set list

" always display status line
set laststatus=2

" enable filetypes plugins
filetype plugin indent on

" vim theme settings
hi Normal ctermbg=none
colorscheme PaperColor
set background=dark

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

" spelling
setlocal spell
map <silent> <leader>ss :setlocal spell!<cr>

" quickly edit/reload vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" do not close the buffer, hide them to preserve
" markers, undo etc
set hidden

" increase history sized
set history=1000
set undolevels=1000

" in case we forgot sudo
cmap w!! w !sudo tee % >/dev/null

" normal OS clipboard interaction
set clipboard=unnamed
