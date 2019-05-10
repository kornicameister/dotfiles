" general settings
setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal foldmethod=indent
setlocal nowrap

setlocal indentexpr=GetYamlIndent()
setlocal indentkeys=o,O,*<Return>,!^F

function! GetYamlIndent()
  let prevlnum = v:lnum - 1
  if prevlnum == 0
    return 0
  endif
  let line = substitute(getline(v:lnum),'\s\+$','','')
  let prevline = substitute(getline(prevlnum),'\s\+$','','')

  let indent = indent(prevlnum)
  let increase = indent + &sw
  let decrease = indent - &sw

  if prevline =~ ':$'
    return increase
  elseif prevline =~ '^\s\+\-' && line =~ '^\s\+[^-]\+:'
    return decrease
  else
    return indent
  endif
endfunction

let b:ale_linters = ['yamllint']
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'prettier']
