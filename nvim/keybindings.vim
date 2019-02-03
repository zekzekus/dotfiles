nnoremap <Space> <nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

" files
nnoremap <silent><leader>ff :<c-u>Denite file_rec buffer -winheight=`30*winheight(0)/100`<cr>
nnoremap <silent><leader>fj :<c-u>Denite junkfile -winheight=`30*winheight(0)/100`<cr>
nnoremap <leader>ft <ESC>:TagbarToggle<cr>
nnoremap <leader>fs <ESC>:w<cr>
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR> " remove trailing whitespace

" buffers
nnoremap <silent><leader>bb :<c-u>Denite buffer -winheight=`30*winheight(0)/100`<cr>
nnoremap <leader>bd :bd<cr>
nnoremap <leader><tab> :b#<CR>

" search
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <leader>/ :<C-u>lgrep!<Space>
nnoremap <leader>* :lgrep! "\b<C-R><C-W>\b"<CR>
nnoremap <BS> :nohlsearch<cr>
nnoremap <silent><leader>ss :<c-u>Denite outline line -winheight=`30*winheight(0)/100`<cr>
nnoremap <leader>sl :<c-u>ilist //<Left>
nmap <silent>[s <Plug>DashSearch
nmap <silent>[<C-s> <Plug>DashGlobalSearch

" for browsing the input history
cnoremap <c-n> <down>
cnoremap <c-p> <up>

nmap - <Plug>VinegarVerticalSplitUp

" Select just pasted text.
nnoremap <leader>V V`]

" keep cursor centered while page up/down like operations
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

function! SetupCR()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction
nnoremap cq :call SetupCR()<CR>*``qz
nnoremap cQ :call SetupCR()<CR>#``qz
vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
vnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"

call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:jump_to_next_source>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:jump_to_previous_source>', 'noremap')
call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplitswitch>', 'noremap')

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <silent>K :call LanguageClient#textDocument_hover()<cr>
    nnoremap <silent>[<C-d> :call LanguageClient#textDocument_definition()<cr>
    nnoremap <silent>[d :call LanguageClient#textDocument_hover()<cr>
    nnoremap <silent>[<C-n> :call LanguageClient#textDocument_rename()<cr>
    nnoremap <silent>[<C-r> :call LanguageClient#textDocument_references()<cr>
    set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
  endif
endfunction
augroup keybindings_au
  autocmd!

  autocmd FileType python,rust,haskell call LC_maps()
augroup END
