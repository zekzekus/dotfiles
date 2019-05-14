function! zek#listinfos()
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) : ''
  return qflist . loclist
endfunction

function! zek#custom_highlights()
  highlight clear Pmenu
  highlight link Pmenu QuickFixLine
  highlight clear StatusLine
  highlight link StatusLine Pmenu
endfunction

function! zek#do_remote()
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

function! zek#setup_cr()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction

function! zek#lc_maps()
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <leader>rn <Plug>(coc-rename)
  nnoremap <silent> K :call CocAction('doHover')<cr>
  setlocal formatexpr=CocAction('formatSelected')
endfunction
