" copyright kornicameister

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Nopik/vim-nerdtree-direnter'

let NERDTreeIgnore=['elmi', 'elmo','\.pyc$', '__pycache__', '\~$']
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

" always open
autocmd vimenter * NERDTree

" open tabs always
let g:NERDTreeMapOpenInTab='<ENTER>'

" open with <F4>
nnoremap <F4> :NERDTreeTabsToggle<CR>
