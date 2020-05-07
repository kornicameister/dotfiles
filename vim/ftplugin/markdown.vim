if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

setlocal spell
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal textwidth=99

let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'prettier']

function kvim::markdownBold()
endfunction

function kvim::mardownItalic()
endfunction

function kvim::wrapBold()
endfunction

function kvim::wrapItalic()
endfunction

" generate toc
nmap <buffer> <silent> <Leader>toc :GenTocGFM<CR>

" in insert mode
imap <buffer> <silent> <C-b> :call kvim::markdownBold<CR>
imap <buffer> <silent> <C-i> :call kvim::mardownItalic<CR>

" in normal mode, wrap word with specific marker
" via vim-surround
nmap <buffer> <silent> <C-b> :call kvim::wrapBold<CR>
nmap <buffer> <silent> <C-i> :call kvim::wrapItalic>CR>
