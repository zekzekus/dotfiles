function! zek#listinfos()
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . '✓' . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) . '✗' . ' ' : ''
  return qflist . loclist
endfunction

function! zek#setup_cr()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction

function! zek#lc_maps()
  nnoremap <C-p> :call LanguageClient_contextMenu()<cr>
endfunction

function! zek#post_colorscheme()
  highlight StatusLineNC guibg=#434c5e
  highlight link clojureParen clojureComment
endfunction

function! zek#pre_colorscheme()
let g:duo_mini_bg = '#2e3340'
endfunction

function! zek#custom_projections()
  for [root, value] in projectionist#query('suffixesadd')
    let &l:suffixesadd = value
  endfor
endfunction

function! zek#denite_settings()
  setlocal signcolumn=no cursorline
  nnoremap <silent><buffer><expr>         <CR>    denite#do_map('do_action')
  nnoremap <silent><buffer><expr>         i       denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr>         p       denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr>         <C-t>   denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr>         <C-v>   denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr>         q       denite#do_map('quit')
  nnoremap <silent><buffer><expr>         r       denite#do_map('redraw')
  nnoremap <silent><buffer><expr>         <Esc>   denite#do_map('quit')
  nnoremap <silent><buffer><expr>         <Tab>   denite#do_map('choose_action')
  nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
endfunction

function! zek#denite_filter_settings()
  setlocal signcolumn=yes nocursorline nonumber norelativenumber
  nmap     <silent><buffer> <Esc> <Plug>(denite_filter_quit)
  imap     <silent><buffer> <Esc> <Plug>(denite_filter_quit)
  nmap     <silent><buffer> <C-c> <Plug>(denite_filter_quit)
  imap     <silent><buffer> <C-c> <Plug>(denite_filter_quit)
  inoremap <silent><buffer> <C-j> <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
  inoremap <silent><buffer> <C-k> <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
endfunction
