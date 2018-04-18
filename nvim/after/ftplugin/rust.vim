let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'T:types,type definitions',
        \'f:functions,function definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'m:modules,module names',
        \'c:consts,static constants',
        \'t:traits,traits',
        \'i:impls,trait implementations',
    \]
    \}

let g:racer_experimental_completer = 1

nmap <leader>md <Plug>(rust-def)
nmap <leader>mD <Plug>(rust-def-split-vertical)
nmap <leader>mi <Plug>(rust-doc)
