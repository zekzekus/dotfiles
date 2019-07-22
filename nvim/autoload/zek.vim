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

  highlight link clojureKeyword clojureSymbol
  highlight link clojureFunc clojureSymbol
  highlight link clojureParen clojureString
  highlight link clojureRepeat clojureSymbol
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

function! zek#denite_maps()
  nnoremap <silent><buffer><expr> <esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
  nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
endfunction

function! zek#denite_filter_maps()
  inoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <esc> denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-v> denite#do_map('do_action', 'vsplitswitch')
  inoremap <silent><buffer><expr> <C-e> denite#do_map('do_action', 'edit')
  inoremap <silent><buffer> <C-j> <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
  inoremap <silent><buffer> <C-k> <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
endfunction

function! zek#check_backspace()
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
