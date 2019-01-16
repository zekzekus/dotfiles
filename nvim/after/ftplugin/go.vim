let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0

" keybindings
nmap <buffer>[<C-d> <Plug>(go-def)
nmap <buffer>K <Plug>(go-info)
nmap <buffer>[d <Plug>(go-doc)
nmap <buffer>[<C-n> <Plug>(go-rename)
