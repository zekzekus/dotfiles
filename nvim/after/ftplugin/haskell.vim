scriptencoding utf-8

" buffer local options
setlocal formatprg=brittany
setlocal expandtab
setlocal omnifunc=necoghc#omnifunc

" plugin settings
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }

let g:haskell_classic_highlighting = 1
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2

AddTabularPattern! colon                  /^[^:]*\zs:/
AddTabularPattern! haskell_bindings       /^[^=]*\zs=\ze[^[:punct:]]/
AddTabularPattern! haskell_comments       /--.*/l2
AddTabularPattern! haskell_do_arrows      / \(<-\|←\) /l0r0
AddTabularPattern! haskell_imports        /^[^(]*\zs(.*\|\<as\>.*/
AddTabularPattern! haskell_pattern_arrows / \(->\|→\) /l0r0
AddTabularPattern! haskell_types          / \(::\|∷\) /l0r0

let g:neomake_haskell_enabled_makers = []
