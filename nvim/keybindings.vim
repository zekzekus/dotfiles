nnoremap <Space> <nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

nnoremap j gj
nnoremap k gk

" files
nnoremap <silent><leader>ff :<c-u>Denite file_rec buffer -winheight=`30*winheight(0)/100`<cr>
nnoremap <silent><leader>fj :<c-u>Denite junkfile -winheight=`30*winheight(0)/100`<cr>
nnoremap <leader>ft <ESC>:TagbarToggle<cr>
nnoremap <leader>fs <ESC>:w<cr>
" to remove white space from a file.
nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

" buffers
nmap <leader>bb :buffers<CR>
nnoremap <leader>bd :bd<cr>
nnoremap <leader><tab> :b#<CR>

" search
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <leader>/ :<C-u>grep!<Space>
nnoremap <leader>* :grep! "\b<C-R><C-W>\b"<CR>
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

nnoremap <leader>o <c-w><Bar><c-w>_<cr>
nnoremap <leader>= <c-w>=

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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

  autocmd FileType * call LC_maps()
augroup END

nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

function! <sid>CCR()
  if getcmdtype() isnot# ':'
    return "\<CR>"
  endif
  let cmdline = getcmdline()
  if cmdline =~# '\v^\s*(ls|files|buffers)!?\s*(\s[+\-=auhx%#]+)?$'
    return "\<CR>:b\<Space>"
  elseif cmdline =~# '\v/(#|nu%[mber])$'
    return "\<CR>:"
  elseif cmdline =~# '\v^\s*(dli%[st]|il%[ist])!?\s+\S'
    return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
  elseif cmdline =~# '\v^\s*(cli|lli)%[st]!?\s*(\s\d+(,\s*\d+)?)?$'
    return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
  elseif cmdline =~# '\v^\s*ol%[dfiles]\s*$'
    set nomore
    return "\<CR>:sil se more|e #<"
  elseif cmdline =~# '^\s*changes\s*$'
    set nomore
    return "\<CR>:sil se more|norm! g;\<S-Left>"
  elseif cmdline =~# '\v^\s*ju%[mps]'
    set nomore
    return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
  elseif cmdline =~ '\v^\s*marks\s*(\s\w+)?$'
    return "\<CR>:norm! `"
  elseif cmdline =~# '\v^\s*undol%[ist]'
    return "\<CR>:u "
  elseif cmdline =~# '\C^reg'
    return "\<CR>:norm! \"p\<Left>"
  else
    return "\<c-]>\<CR>"
  endif
endfunction
cnoremap <expr> <CR> <sid>CCR()
