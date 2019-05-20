" general settings
setlocal spell
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal textwidth=99

nmap <buffer> <silent> <Leader>toc :GenTocGFM<CR>   " generate TOC quicker
imap <buffer> <silent> <C-B> :call InsertBold>CR>   " insert bold

fu! InsertBold(){
  echom 'test'
}

let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'prettier']
