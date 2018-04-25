" Copyright 2018 @ kornicameister

Plug 'bronson/vim-trailing-whitespace'

autocmd BufEnter * FixWhitespace
autocmd BufWritePre * FixWhitespace
