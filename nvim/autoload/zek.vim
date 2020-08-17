function! zek#listinfos()
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . '✓' . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) . '✗' . ' ' : ''
  return qflist . loclist
endfunction

function! zek#lc_maps()
  nnoremap <C-p> :call LanguageClient_contextMenu()<cr>
  nnoremap <leader>d :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>mn :call LanguageClient#textDocument_references()<CR>
endfunction
