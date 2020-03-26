nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

" files
noremap <silent><leader>ff :<c-u>Denite file/rec<cr>
nnoremap <silent><leader>fj :<c-u>Denite file/rec:~/.cache/junkfile<cr>
nnoremap <leader>fs <ESC>:w<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

" buffers
nnoremap <leader>bd :<c-u>bdelete<cr>
nnoremap <silent><leader>bb :<c-u>Denite buffer<cr>
nnoremap <leader><tab> :b#<CR>

" search
command! -nargs=+ -complete=file_in_path -bar Zgrep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <BS> :nohlsearch<cr>
nnoremap <silent><leader>ss :<c-u>Denite outline<cr>
nnoremap <silent><leader>sl :<c-u>Denite line<cr>

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nnoremap <silent><leader>qq :SmartClose<cr>

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
  autocmd FileType ruby,python,rust,haskell,go,javascript call zek#lc_maps()
  autocmd FileType denite call zek#denite_settings()
  autocmd FileType denite-filter call zek#denite_filter_settings()
augroup END
