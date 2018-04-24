" Copyright 2018 @ kornicameister

" ctrlp
Plug 'kien/ctrlp.vim'

let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.elmi,*.elmo

" ctrlp-funky
Plug 'tacahiroy/ctrlp-funky'

" map the key
nnoremap <Leader>fu :CtrlPFunky<Cr>
" narrow the list down with a word under cursor
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
