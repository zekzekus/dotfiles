nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

" my commands
command! -nargs=0 -bar Zlist cclose | cgetexpr system("rg --files --hidden --follow --glob \"!.git\"")
command! -nargs=1 -bar Zfind cclose | cgetexpr system("ff <args>")
command! -nargs=0 -bar Zjunk cclose | cgetexpr system("rg --files ~/.cache/junkfile")
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))

" files
nnoremap <leader>ft <ESC>:Vista!!<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR> " remove trailing whitespace

" buffers
nnoremap <leader><tab> :b#<CR>

" search
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <BS> :nohlsearch<cr>

nnoremap yom :match ErrorMsg /\%>80c/<cr>
nnoremap yoM :match none /\%>80c/<cr>

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nmap - <Plug>VinegarVerticalSplitUp

" Select just pasted text.
nnoremap <leader>V V`]

noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
noremap <C-f> <C-f>zz
noremap <C-b> <C-b>zz

nnoremap <silent><leader>qq :SmartClose<cr>

let g:mc = 'y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>'
nnoremap cn *``cgn
nnoremap cN *``cgN
vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

nnoremap cq :call zek#setup_cr()<CR>*``qz
nnoremap cQ :call zek#setup_cr()<CR>#``qz
vnoremap <expr> cq ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr> cQ ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-y>" : zek#check_backspace() ? "\<TAB>" : coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

augroup keybindings_au
  autocmd!

  autocmd FileType python,rust,haskell,go,javascript,scala call zek#lc_maps()
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

function! CCR()
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(ls|files|buffers)'
        return "\<CR>:b"
    elseif cmdline =~ '\v\C^(dli|il)'
        return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
    elseif cmdline =~ '\v\C^(cli|lli)'
        return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
    else
        return "\<CR>"
    endif
endfunction
cnoremap <expr> <CR> CCR()
