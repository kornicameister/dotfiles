" Copyright 2018 kornicameister

" leader
let mapleader = ','
let g:mapleader = ','

" save from typing :
nnoremap ; :

" general settings for editor
syntax on

set encoding=utf-8
scriptencoding utf-8

set smartindent
set noerrorbells
set novisualbell
set timeoutlen=500

" searching stuff
nnoremap n nzzzv                            " center line on next search
nnoremap N Nzzzv                            " -----------//------------

" no temp or backup files
set noswapfile
set nobackup
set nowritebackup

set nowrap              " do not wrap lines

" tabs settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" indentation settings
set autoindent
set copyindent

" disable modelines
set modelines=0
set nomodeline

" set title
set title

" make searching smart
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m
endif
set ignorecase
set smartcase

" Make the keyboard fast
set ttyfast
set timeout timeoutlen=1000 ttimeoutlen=50

" always safe on focus lost
au FocusLost * :wa
set autoread

" backspace fix
set backspace=indent,eol,start
if ! has('nvim')
  fixdel
endif

" wrap movement
set whichwrap+=<,>,h,l,[,]

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
set cmdheight=1

" open help vertically
command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L

" enable filetypes plugins
filetype plugin indent on

hi Normal ctermfg=252 ctermbg=none
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
if has('termguicolors')
  set termguicolors
endif

" spelling
setlocal spell
map <silent> <leader>ss :setlocal spell!<cr>
hi SpellBad cterm=underline,bold ctermfg=red

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
nnoremap <Space> za
vnoremap <Space> za

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
set clipboard+=unnamedplus

" wilderness
set wildignore+=*.png,*.PNG,*.JPG,*.jpg,*.JPEG,*.jpeg,*.GIF,*.gif,*.pdf,*.PDF
set wildignore+=*.BACKUP.*,*.BASE.*,*.LOCAL.*,*.REMOTE.*
set wildignore+=/tmp/**

set wildmode=longest:full,full
set wildmenu

" vim theme settings
colorscheme dracula
set background=dark

" navigate through the buffers
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> <leader>q :bd<cr>gT
nnoremap <silent> <leader>Q :bufdo bd<CR>
nnoremap <silent> <leader>r :e<CR>
nnoremap <silent> <leader>R :e!<CR>

" fzf mappings
nmap <Leader>t  :Tags<CR>
nmap <Leader>bt :BTags<CR>
nmap <Leader>f  :GFiles<CR>
nmap <Leader>F  :Files<CR>
nmap <Leader>c  :Commits<CR>
nmap <Leader>b  :Buffers<CR>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" ale mapping
nmap <A-f> <Plug>(ale_fix)<CR>
nmap <A-l> <Plug>(ale_lint)<CR>
nmap <A-d> <Plug>(ale_detail)<CR>
nmap <A-k> <Plug>(ale_previous_wrap)
nmap <A-j> <Plug>(ale_next_wrap)
