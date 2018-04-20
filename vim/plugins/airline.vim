" airline plugin stuff

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" integrate with vim-ale
let g:airline#extensions#ale#enabled = 1

" intergrate with tabline
let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'jellybeans'

