scriptencoding utf-8

" Copyright 2018-2020 @ kornicameister
" Contains useful stuff for handling the sessions in Vim

" persistent undo, for making more 'u' operations
if has('persistent_undo')
  set undodir=~/.vim/undodir
  set undofile
  set undolevels=1000
  set undoreload=10000
endif

" Remember info about open buffers on close
set viminfo^=%

augroup restore_position_cursor
  " Return to last edit position when opening files (You want this!)
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END
