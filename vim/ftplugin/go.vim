if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1
let b:ale_fixers = ['gofmt', 'goimports', 'trim_whitespace', 'remove_trailing_lines']

setlocal nolisp
setlocal autoindent
setlocal indentexpr=GoIndent(v:lnum)
setlocal indentkeys+=<:>,0=},0=)
setlocal nospell

augroup vim-go
  autocmd!
  autocmd BufNewFile *.go setlocal fileencoding=utf-8 fileformat=unix
augroup end

function! GoIndent(lnum) abort
  let prevlnum = prevnonblank(a:lnum-1)
  if prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let prevl = substitute(getline(prevlnum), '//.*$', '', '')
  let thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let previ = indent(prevlnum)

  let ind = previ

  for synid in synstack(a:lnum, 1)
    if synIDattr(synid, 'name') == 'goRawString'
      if prevl =~ '\%(\%(:\?=\)\|(\|,\)\s*`[^`]*$'
        " previous line started a multi-line raw string
        return 0
      endif
      " return -1 to keep the current indent.
      return -1
    endif
  endfor

  if prevl =~ '[({]\s*$'
    " previous line opened a block
    let ind += shiftwidth()
  endif
  if prevl =~# '^\s*\(case .*\|default\):$'
    " previous line is part of a switch statement
    let ind += shiftwidth()
  endif
  " TODO: handle if the previous line is a label.

  if thisl =~ '^\s*[)}]'
    " this line closed a block
    let ind -= shiftwidth()
  endif

  " Colons are tricky.
  " We want to outdent if it's part of a switch ("case foo:" or "default:").
  " We ignore trying to deal with jump labels because (a) they're rare, and
  " (b) they're hard to disambiguate from a composite literal key.
  if thisl =~# '^\s*\(case .*\|default\):$'
    let ind -= shiftwidth()
  endif

  return ind
endfunction
