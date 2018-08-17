" general settings
setlocal spell
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal textwidth=99

" generate TOC quicker
nmap <buffer> <silent> <Leader>toc :GenTocGFM<CR>

let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'prettier']
