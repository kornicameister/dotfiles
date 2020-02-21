setlocal foldmethod=syntax
setlocal nospell

let b:ale_linters = ['elm_ls']
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'elm-format']
let b:ale_linters_ignore = { 'elm': ['make'] }
