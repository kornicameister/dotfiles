" autocommand, whenever save file ~/.vimrc, it gets automatically sourced
:au! BufWritePost $MYVIMRC source $MYVIMRC

" plugins
source ~/.vim/k/plugins.vim
source ~/.vim/k/editor.vim

""" editior settings

" vim-ansible-yaml
let g:ansible_options = {'ignore_blank_lines': 0}
let g:ansible_options = {'documentation_mapping': '<C-K>'} "ctrl-k for docs

" vim-arline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'simple'
set laststatus=2

" rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

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

