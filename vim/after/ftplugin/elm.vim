setlocal foldmethod=syntax
setlocal nospell

let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'elm-format']

function! s:SetTagbar()
  if !exists('b:tagbar_type_elm')
  endif
endfunction

call s:SetTagbar()
