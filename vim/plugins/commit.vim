" Copyright 2017 @ kornicameister
"
" Plugins for the commit msg handling

Plug 'rhysd/committia.vim'
Plug 'scrooloose/nerdcommenter'

let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction


" Spell check markdown, git and mercurial commit messages
" It is possible to add words to your own dictionary using the `zg` key
" combination. You can undo the add with `zug`.
" It is also possible to mark a word as incorrectly spelled using `zw`.
" `zuw` undoes the incorrect marking.
" You can jump forwards/backwards to the next flagged word using `]s` and `[s`.
" Once you've located a word, z= will bring up the list of suggested words.
au FileType markdown  setlocal spell
au FileType gitcommit setlocal spell
au FileType asciidoc  setlocal spell
