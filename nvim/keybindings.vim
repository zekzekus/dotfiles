nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

nnoremap <leader><space> :<c-u>Denite command<cr>

" files
nnoremap <silent><leader>ff :<c-u>Denite file/rec<cr>
nnoremap <silent><leader>fj :<c-u>Denite junkfile<cr>
nnoremap <leader>ft <ESC>:Vista!!<cr>
nnoremap <leader>fs <ESC>:w<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR> " remove trailing whitespace

" buffers
nnoremap <leader>bd :<c-u>bdelete<cr>
nnoremap <leader>bD :<c-u>bdelete!<cr>
nnoremap <silent><leader>bb :<c-u>Denite buffer<cr>
nnoremap <leader><tab> :b#<CR>

" search
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <leader>/ :<C-u>Grep<space>
nnoremap <leader>* :<C-u>Grep <C-R><C-W><cr>
nnoremap <BS> :nohlsearch<cr>
nnoremap <silent><leader>ss :<c-u>Denite outline line<cr>

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
  autocmd FileType denite-filter call zek#denite_filter_maps()
  autocmd FileType denite call zek#denite_maps()
  autocmd FileType denite,denite-filter let b:coc_suggest_disable = 1
augroup END
