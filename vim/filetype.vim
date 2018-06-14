" Copyright 2018 @ kornicameister

augroup fileTypeDetect
  au!
  au BufNewFile,BufRead gitconfig setlocal ft=config
augroup END

augroup pythonSettings
  au!
  au BufRead,BufNewFile *.py,*.pyw setlocal et ai tw=79 ts=4 sts=4 sw=4
  au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
  au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/
  au         BufNewFile *.py,*.pyw setlocal fileformat=unix
  au BufRead,BufNewFile *.py,*.pyw let b:comment_leader = '#'
augroup END

augroup jsSettings
  au!
  au BufRead,BufNewFile *.js,*.jsx set et ai ts=4 sts=4 sw=4 tw=79
  au BufRead,BufNewFile *.js,*.jsx match BadWhitespace /^\t\+/
  au BufRead,BufNewFile *.js,*.jsx match BadWhitespace /\s\+$/
  au         BufNewFile *.js,*.jsx set fileformat=unix
  au BufRead,BufNewFile *.js,*.jsx let b:comment_leader = '//'
augroup END

au BufNewFile,BufRead *.vim setlocal ai et ts=2 sw=2 sts=2
au BufNewFile,BufRead *.txt setlocal et ts=4 sw=4
au BufNewFile,BufRead *.md setlocal spell et ts=4 sw=4 tw=99
au BufNewFile,BufRead *.yml,*.yaml setlocal et ts=2 sw=2
au BufNewFile,BufRead *.cpp setlocal et ts=2 sw=2
au BufNewFile,BufRead *.hpp setlocal et ts=2 sw=2
au BufNewFile,BufRead *.json setlocal et ts=2 sw=2
au BufNewFile,BufRead *.jade setlocal et ts=2 sw=2

au FileType gitcommit setlocal spell
au FileType asciidoc  setlocal spell
au FileType elm setlocal foldmethod=syntax
au FileType json setlocal foldmethod=syntax
