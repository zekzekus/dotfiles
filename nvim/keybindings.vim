nnoremap <Space> <nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

nnoremap d "_d

function! s:python_bindings()
  nnoremap <silent> <leader>md :call jedi#goto()<cr>
  nnoremap <silent> <leader>mg :call jedi#goto_assignments()<cr>
  nnoremap <silent> <leader>mr :call jedi#rename()<cr>
  nnoremap <silent> <leader>mn :call jedi#usages()<cr>
endfunction

function! s:haskell_bindings()
  nnoremap <Leader>mio :InteroOpen<CR>
  nnoremap <Leader>mik :InteroKill<CR>
  nnoremap <Leader>mic :InteroHide<CR>
  nnoremap <Leader>mil :InteroLoadCurrentModule<CR>

  nnoremap <Leader>me :InteroEval<CR>
  nnoremap <Leader>mt :InteroGenericType<CR>
  nnoremap <Leader>mT :InteroType<CR>
  nnoremap <Leader>mi :InteroInfo<CR>
  nnoremap <Leader>mI :InteroTypeInsert<CR>

  nnoremap <Leader>md :InteroGoToDef<CR>

  nnoremap <Leader>mu :InteroUses<CR>

  augroup haskell_intero
    autocmd!
    autocmd BufWritePost *.hs InteroReload
  augroup END
endfunction

function! s:go_bindings()
  nmap <leader>md <Plug>(go-def)
  nmap <leader>mt <Plug>(go-info)
  nmap <leader>mi <Plug>(go-info)
  nmap <leader>mr <Plug>(go-rename)
endfunction

function! s:rust_bindings()
  nmap <buffer><leader>md <Plug>(rust-def)
  nmap <buffer><leader>mD <Plug>(rust-def-split-vertical)
  nmap <buffer><leader>mi <Plug>(rust-doc)
endfunction

function! s:general_bindings()
  " vim handles long lines nicely with these
  nnoremap j gj
  nnoremap k gk

  " files
  nmap <leader>ft <ESC>:TagbarToggle<cr>
  nmap <leader>fs <ESC>:w<cr>
  nnoremap <silent> <leader>ff :<c-u>Denite file_rec -winheight=`30*winheight(0)/100`<cr>
  nnoremap <silent> <leader>fj :<c-u>Denite junkfile -winheight=`30*winheight(0)/100`<cr>
  " to remove white space from a file.
  nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

  " buffers
  nnoremap <silent> <leader>bb :<c-u>Denite buffer -winheight=`30*winheight(0)/100`<cr>
  nnoremap <leader><tab> :b#<CR>

  " search
  nnoremap / /\v
  vnoremap / /\v
  nnoremap n nzzzv
  nnoremap N Nzzzv
  nnoremap <silent> <leader>/ :<c-u>Denite -auto-preview -vertical-preview grep<cr>
  nnoremap <silent> <leader>* :<c-u>DeniteCursorWord -auto-preview -vertical-preview grep<cr>
  nnoremap <leader>ss :Grepper -tool ag -quickfix -open -switch -nojump -prompt<cr>
  nnoremap <leader>sS :Grepper -side -tool ag -prompt<cr>
  nnoremap <silent><BS> :noh<cr>
  nnoremap <leader>. :Grepper -cword -noprompt<cr>

  " for browsing the input history
  cnoremap <c-n> <down>
  cnoremap <c-p> <up>

  nmap - <Plug>VinegarVerticalSplitUp

  " Select just pasted text.
  nnoremap <leader>V V`]

  nnoremap <silent> <leader>l :<c-u>Denite line<cr>
  nnoremap <silent> <leader>y :<c-u>Denite outline -winheight=`30*winheight(0)/100`<cr>
  nnoremap <silent> <leader>r :<c-u>Denite register<cr>

  nnoremap <silent><leader>qq :SmartClose<cr>
  nnoremap <silent><leader>Q :SmartClose<cr>
  vnoremap <silent><leader>Q :SmartClose<cr>

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

  if has('nvim')
    call denite#custom#map(
          \ 'insert',
          \ '<C-j>',
          \ '<denite:move_to_next_line>',
          \ 'noremap'
          \)
    call denite#custom#map(
          \ 'insert',
          \ '<C-k>',
          \ '<denite:move_to_previous_line>',
          \ 'noremap'
          \)

    call denite#custom#map(
          \ 'insert',
          \ '<C-v>',
          \ '<denite:do_action:vsplitswitch>',
          \ 'noremap'
          \)
  endif

  nnoremap <leader>o <c-w><Bar><c-w>_<cr>
  nnoremap <leader>= <c-w>=
endfunction

augroup bindings
  autocmd!
  autocmd VimEnter * call s:general_bindings()
  autocmd FileType haskell,lhaskell call s:haskell_bindings()
  autocmd FileType python,python.django call s:python_bindings()
  autocmd FileType go call s:go_bindings()
  autocmd FileType rust call s:rust_bindings()
augroup END
