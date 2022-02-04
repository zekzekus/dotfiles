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

function! s:zek_post_colorscheme() abort
endfunction

function! s:zek_pre_colorscheme() abort
endfunction

function! zek#set_colorscheme() abort
  call s:zek_pre_colorscheme()
  colorscheme nord
  call s:zek_post_colorscheme()
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

function! s:zek_feedkeys(str) abort
  call feedkeys(a:str, 'n')
endfunction

function! zek#autoreply() abort
  if g:zek_has_replied
    let g:zek_has_replied = v:false
    return
  endif

  let g:zek_has_replied = v:true

  let previous_cmdline  = getcmdline()
  let previous_cmd      = split(previous_cmdline)[0]
  let previous_args     = split(previous_cmdline)[1:]

  let ignorecase    = &ignorecase
  set noignorecase
  let previous_cmd  = get(getcompletion(previous_cmd, 'command'), 0)
  let &ignorecase   = ignorecase

  if empty(previous_cmd)
    return
  endif

  if previous_cmd ==# 'global'
    call s:zek_feedkeys(':')
  elseif previous_cmd ==# 'undolist'
    call s:zek_feedkeys(':undo' . ' ')
  elseif previous_cmd ==# 'oldfiles'
    call s:zek_feedkeys(':edit #<')
  elseif previous_cmd ==# 'marks'
    call s:zek_feedkeys(':normal! `')
  elseif previous_cmd ==# 'changes'
    call s:zek_feedkeys(':normal! g;')
    call s:zek_feedkeys("\<S-Left>")
  elseif previous_cmd ==# 'jumps'
    call s:zek_feedkeys(':normal!' . ' ')
    call s:zek_feedkeys("\<C-O>\<S-Left>")
  elseif previous_cmd ==# 'registers'
    call s:zek_feedkeys(':normal! "p')
    call s:zek_feedkeys("\<Left>")
  elseif previous_cmd ==# 'tags'
    call s:zek_feedkeys(':pop')
    call s:zek_feedkeys("\<Home>")
  elseif index(['ls', 'files', 'buffers'], previous_cmd) != -1
    call s:zek_feedkeys(':buffer' . ' ')
  elseif index(['clist', 'llist'], previous_cmd) != -1
    call s:zek_feedkeys(':' . repeat(previous_cmd[0], 2) . ' ')
  elseif index(['dlist', 'ilist'], previous_cmd) != -1
    call s:zek_feedkeys(':' . previous_cmd[0] . 'jump' . ' ' . join(previous_args))
    call s:zek_feedkeys("\<Home>\<S-Right>\<Space>")
  else
    let g:zek_has_replied = v:false
  endif
endfunction

function! zek#grep(...) abort
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

function! zek#show_highlight() abort
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
