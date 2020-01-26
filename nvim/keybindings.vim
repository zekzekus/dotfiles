nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

" files
nnoremap <silent><leader>ff :<c-u>Files<cr>
nnoremap <silent><leader>fj :<c-u>Files ~/.cache/junkfile<cr>

" buffers
nnoremap <silent><leader>bb :<c-u>Buffers<cr>
nnoremap <leader><tab> :b#<CR>

" search
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <BS> :nohlsearch<cr>

nnoremap yom :match ErrorMsg /\%>80c/<cr>
nnoremap yoM :match none /\%>80c/<cr>

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nnoremap <silent><leader>qq :pclose<cr>:cclose<cr>:helpclose<cr>:lclose<cr>

" Select just pasted text.
nnoremap <leader>V V`]

let g:mc = 'y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>'
nnoremap cn *``cgn
nnoremap cN *``cgN
vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

nnoremap cq :call zek#setup_cr()<CR>*``qz
nnoremap cQ :call zek#setup_cr()<CR>#``qz
vnoremap <expr> cq ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr> cQ ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"

augroup keybindings_au
  autocmd!
  autocmd FileType ruby,python,rust,haskell,go,javascript,scala call zek#lc_maps()
augroup END
