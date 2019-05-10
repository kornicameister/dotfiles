" general settings
setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=4
setlocal foldmethod=indent
setlocal nowrap

let b:ale_linters = ['yamllint']
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'prettier']
