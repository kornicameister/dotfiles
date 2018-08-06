setlocal expandtab
setlocal autoindent
setlocal smartindent
setlocal textwidth=79
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal fileformat=unix

set backspace=indent,eol,start

match BadWhitespace /^\t\+/
match BadWhitespace /\s\+$/

let b:comment_leader = '#'
let b:ale_fix_on_save = 0
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'yapf']
