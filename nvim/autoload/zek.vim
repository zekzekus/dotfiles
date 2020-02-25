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

function! zek#my_highlights()
  if !has("nvim")
    highlight StatusLine cterm=none
    highlight CursorLine cterm=none
    highlight VertSplit cterm=none
    highlight CursorLineNr cterm=none
  endif
  highlight PmenuSel guifg=#23272e guibg=#56b6c2
  highlight StatusLine guifg=#23272e guibg=#56b6c2
endfunction

function! zek#custom_projections()
  for [root, value] in projectionist#query('suffixesadd')
    let &l:suffixesadd = value
  endfor
endfunction
