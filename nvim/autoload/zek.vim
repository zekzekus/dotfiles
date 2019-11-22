function! zek#listinfos()
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . '✓' . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) . '✗' . ' ' : ''
  return qflist . loclist
endfunction

function! zek#do_remote(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

function! zek#lc_maps()
  nnoremap <C-p> :call LanguageClient_contextMenu()<cr>
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
endfunction
