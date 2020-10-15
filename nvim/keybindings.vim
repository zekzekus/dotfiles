nnoremap <space> <nop>
let g:mapleader = "\<space>"
let g:maplocalleader = '\'

" commands
command! -nargs=1 -complete=command      -bar -range Zredir call zek#redir(<q-args>, <range>, <line1>, <line2>)
command! -nargs=+ -complete=file_in_path -bar        Zgrep  cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))
command! -nargs=+                        -bar        Zfiles cgetexpr system('ff ' . shellescape(<q-args>) . ' .')
command! -nargs=?                        -bar        Zjunk  cgetexpr system('ff ' . shellescape(<q-args>) . ' ~/.cache/junkfile')

" files
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fj :Files ~/.cache/junkfile<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

" buffers
nnoremap <leader>bb    :Buffers<cr>
nnoremap <leader><tab> :b#<CR>

" search
nnoremap n          nzzzv
nnoremap N          Nzzzv
nnoremap <BS>       :nohlsearch<cr>
nnoremap <leader>ss :BTags<cr>
nnoremap <leader>sl :BLines<cr>

nmap     -     <Plug>VinegarVerticalSplitUp
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nnoremap <silent><leader>qq :SmartClose<cr>

" Select just pasted text.
nnoremap <leader>V V`]

let g:mc = 'y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>'
nnoremap cn     *``cgn
nnoremap cN     *``cgN
vnoremap <expr> cn g:mc . "``cgn"
vnoremap <expr> cN g:mc . "``cgN"

nnoremap cq       :call zek#setup_cr()<CR>*``qz
nnoremap cQ       :call zek#setup_cr()<CR>#``qz
vnoremap <expr>cq ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr>cQ ":\<C-u>call zek#setup_cr()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"

augroup keybindings_au
  autocmd!
  autocmd FileType rust,haskell,javascript,python,ruby,scala call zek#lsp_bindings()
augroup END
