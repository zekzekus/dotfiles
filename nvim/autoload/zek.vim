function! zek#updateremote(arg) abort
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

function! zek#listinfos() abort
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . '✓' . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) . '✗' . ' ' : ''
  return qflist . loclist
endfunction

function! zek#setup_cr() abort
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction

function! zek#post_colorscheme() abort
  highlight StatusLineNC guibg=#434c5e
  highlight link clojureParen clojureComment
endfunction

function! zek#pre_colorscheme() abort
  let g:duo_mini_bg = '#2e3340'
endfunction

function! zek#custom_projections() abort
  for [root, value] in projectionist#query('suffixesadd')
    let &l:suffixesadd = value
  endfor
endfunction

function! zek#redir(cmd, rng, start, end) abort
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~? '^!'
    let cmd = a:cmd =~?' %'
          \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
          \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . ' <<< $' . cleaned_lines)
    endif
  else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, output)
endfunction
