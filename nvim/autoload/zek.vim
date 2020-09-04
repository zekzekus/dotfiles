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
  if g:colors_name ==# 'duo-mini'
    highlight StatusLineNC guibg=#434c5e
    highlight link clojureParen clojureComment
  elseif g:colors_name ==# 'parchment'
    highlight clear VertSplit
  endif
endfunction

function! zek#pre_colorscheme() abort
  let g:duo_mini_bg = '#2e3340'
endfunction

function! zek#set_colorscheme() abort
  call zek#pre_colorscheme()
  if $ITERM_PROFILE =~? 'light'
    colorscheme parchment
  else
    colorscheme menguless
  endif
  call zek#post_colorscheme()
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

function! zek#feedkeys(str) abort
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
    call zek#feedkeys(':')
  elseif previous_cmd ==# 'undolist'
    call zek#feedkeys(':undo' . ' ')
  elseif previous_cmd ==# 'oldfiles'
    call zek#feedkeys(':edit #<')
  elseif previous_cmd ==# 'marks'
    call zek#feedkeys(':normal! `')
  elseif previous_cmd ==# 'changes'
    call zek#feedkeys(':normal! g;')
    call zek#feedkeys("\<S-Left>")
  elseif previous_cmd ==# 'jumps'
    call zek#feedkeys(':normal!' . ' ')
    call zek#feedkeys("\<C-O>\<S-Left>")
  elseif previous_cmd ==# 'registers'
    call zek#feedkeys(':normal! "p')
    call zek#feedkeys("\<Left>")
  elseif previous_cmd ==# 'tags'
    call zek#feedkeys(':pop')
    call zek#feedkeys("\<Home>")
  elseif index(['ls', 'files', 'buffers'], previous_cmd) != -1
    call zek#feedkeys(':buffer' . ' ')
  elseif index(['clist', 'llist'], previous_cmd) != -1
    call zek#feedkeys(':' . repeat(previous_cmd[0], 2) . ' ')
  elseif index(['dlist', 'ilist'], previous_cmd) != -1
    call zek#feedkeys(':' . previous_cmd[0] . 'jump' . ' ' . join(previous_args))
    call zek#feedkeys("\<Home>\<S-Right>\<Space>")
  else
    let g:zek_has_replied = v:false
  endif
endfunction

function zek#lsp_bindings() abort
  nnoremap <silent><C-p> :call LanguageClient_contextMenu()<cr>
endfunction
