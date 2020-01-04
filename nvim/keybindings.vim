nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

" files
nnoremap <silent><leader>ff :<c-u>Files<cr>
nnoremap <silent><leader>fj :<c-u>Files ~/.cache/junkfile<cr>
nnoremap <leader>ft <ESC>:Vista!!<cr>
nnoremap <leader>fs <ESC>:w<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

" buffers
nnoremap <leader>bd :<c-u>bdelete<cr>
nnoremap <leader>bD :<c-u>bdelete!<cr>
nnoremap <silent><leader>bb :<c-u>Buffers<cr>
nnoremap <leader><tab> :b#<CR>

" search
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <leader>/ :<C-u>Grep<space>
nnoremap <leader>* :<C-u>Grep <C-R><C-W><cr>
nnoremap <silent><leader>ss :<c-u>BTags<cr>
nnoremap <silent><leader>sl :<c-u>BLines<cr>
nnoremap <silent><leader>sL :<c-u>Lines<cr>

nnoremap yom :match ErrorMsg /\%>80c/<cr>
nnoremap yoM :match none /\%>80c/<cr>

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nmap - <Plug>VinegarVerticalSplitUp

" Select just pasted text.
nnoremap <leader>V V`]

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

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

augroup keybindings_au
  autocmd!

  autocmd FileType ruby,python,rust,haskell,go,javascript,scala call zek#lc_maps()
augroup END
