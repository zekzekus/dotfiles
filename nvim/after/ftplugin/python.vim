" plugin settings
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures = 0
let g:jedi#completions_enabled = 0

" keybindings
nnoremap <leader>md :call jedi#goto()<cr>
nnoremap <leader>mg :call jedi#goto_assignments()<cr>
nnoremap <leader>mr :call jedi#rename()<cr>
nnoremap <leader>mn :call jedi#usages()<cr>

