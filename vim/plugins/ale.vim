" Copyright 2017 @ kornicameister

" https://github.com/w0rp/ale
Plug 'w0rp/ale'

" when linting happens
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'never'

" completion stuff
let g:ale_completion_enabled = 1

" small tweaks
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" let g:ale_fixers = {
" \   'javascript': ['eslint', 'tslint', 'trim_whitespace'],
" \   'elm': ['format', 'elm-format', 'trim_whitespace'],
" \   'python': ['autopep8', 'isort', 'yapf', 'trim_whitespace'],
" \   'json': ['fixjson', 'jq', 'trim_whitespace'],
" \   'vim': ['trim_whitespace'],
" \}
"
" let g:ale_linters = {
" \   'elm': ['elm-make', 'elm-format'],
" \   'json': ['json'],
" \   'python': ['flake8', 'pycodestyle', 'pylint'],
" \   'vim': ['vint'],
" \   'dockerfile': ['hadolint'],
" \}
