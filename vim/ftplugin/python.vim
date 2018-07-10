setlocal et ai tw=79 ts=4 sts=4 sw=4 ff=unix

match BadWhitespace /^\t\+/
match BadWhitespace /\s\+$/

let b:comment_leader = '#'
let b:ale_fix_on_save = 0
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'yapf']
