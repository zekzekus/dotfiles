" plugin configuration
let g:neomake_go_enabled_makers = []
let g:go_metalinter_autosave = 1
let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_list_type = 'quickfix'
let g:go_jump_to_error = 0

" keybindings
nmap <buffer>[<C-d> <Plug>(go-def)
nmap <buffer>K <Plug>(go-info)
nmap <buffer>[d <Plug>(go-doc)
nmap <buffer>[<C-n> <Plug>(go-rename)
