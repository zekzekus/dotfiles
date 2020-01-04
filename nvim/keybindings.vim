nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

" files
command! Zfiles Files
command! Zjunkfiles Files ~/.cache/junkfile

" buffers
nnoremap [<tab> :b#<CR>
command! Zbuffers Buffers
command! Zlines BLines
command! Ztags BTags

" search
command! -nargs=+ -complete=file_in_path -bar Zgrep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap yom :match ErrorMsg /\%>80c/<cr>
nnoremap yoM :match none /\%>80c/<cr>

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Select just pasted text.
nnoremap ]v V`]

nnoremap ZZ :SmartClose<cr>

let g:mc = 'y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>'
nnoremap cn *``cgn
nnoremap cN *``cgN
vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

nnoremap cq :call zek#setup_cr()<CR>*``qz
nnoremap cQ :call zek#setup_cr()<CR>#``qz
vnoremap <expr> cq ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr> cQ ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

augroup keybindings_au
  autocmd!

  autocmd FileType ruby,python,rust,haskell,go,javascript,scala call zek#lc_maps()
augroup END
