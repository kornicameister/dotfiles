" autocommand, whenever save file ~/.vimrc, it gets automatically sourced
:au! BufWritePost $MYVIMRC source $MYVIMRC

" plugins
source ~/.vim/plugins.vim

""" editior settings
set smartindent
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

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

" vim-better-whitespace
autocmd BufEnter * EnableStripWhitespaceOnSave
autocmd BufWritePre * EnableStripWhitespaceOnSave

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

" jedi-vim settings
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#use_splits_not_buffers = "left"

