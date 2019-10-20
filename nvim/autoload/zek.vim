function! zek#listinfos()
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) : ''
  return qflist . loclist
endfunction

function! zek#do_remote(arg)
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

function! zek#check_backspace()
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! zek#set_background()
  if $ITERM_PROFILE =~? 'light'
    set background=light
  endif
endfunction

function! zek#float_fzf()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(30)
  let width = float2nr(100)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 1

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction
