nnoremap <Space> <nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

function! s:python_bindings()
  nnoremap <leader>md :call jedi#goto()<cr>
  nnoremap <leader>mg :call jedi#goto_assignments()<cr>
  nnoremap <leader>mr :call jedi#rename()<cr>
  nnoremap <leader>mn :call jedi#usages()<cr>
endfunction

function! s:haskell_bindings()
  nnoremap <leader>mio :InteroOpen<CR>
  nnoremap <leader>mik :InteroKill<CR>
  nnoremap <leader>mic :InteroHide<CR>
  nnoremap <leader>mil :InteroLoadCurrentModule<CR>

  nnoremap <leader>me :InteroEval<CR>
  nnoremap <leader>mt :InteroGenericType<CR>
  nnoremap <leader>mT :InteroType<CR>
  nnoremap <leader>mi :InteroInfo<CR>
  nnoremap <leader>mI :InteroTypeInsert<CR>

  nnoremap <leader>md :InteroGoToDef<CR>

  nnoremap <leader>mu :InteroUses<CR>

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
  nmap <leader>md <Plug>(rust-def)
  nmap <leader>mD <Plug>(rust-def-split-vertical)
  nmap <leader>mi <Plug>(rust-doc)
endfunction

function! s:general_bindings()
  " vim handles long lines nicely with these
  nnoremap j gj
  nnoremap k gk

  " files
  nmap <leader>ft <ESC>:TagbarToggle<cr>
  nmap <leader>fs <ESC>:w<cr>
  nnoremap <silent><leader>ff :<c-u>Denite file_rec -winheight=`30*winheight(0)/100`<cr>
  nnoremap <silent><leader>fj :<c-u>Denite junkfile -winheight=`30*winheight(0)/100`<cr>
  " to remove white space from a file.
  nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

  " buffers
  nnoremap <silent><leader>bb :<c-u>Denite buffer -winheight=`15*winheight(0)/100`<cr>
  nnoremap <leader><tab> :b#<CR>
  nnoremap <silent><leader>bl :<c-u>Denite line<cr>
  nnoremap <silent><leader>by :<c-u>Denite outline -winheight=`30*winheight(0)/100`<cr>

  " search
  nnoremap n nzzzv
  nnoremap N Nzzzv
  nnoremap <silent><leader>/ :<c-u>Denite -auto-preview -vertical-preview grep<cr>
  nnoremap <silent><leader>* :<c-u>DeniteCursorWord -auto-preview -vertical-preview grep<cr>
  nnoremap <leader>ss :Grepper -tool rg -quickfix -open -switch -nojump -prompt<cr>
  nnoremap <leader>. :Grepper -cword -noprompt<cr>
  nnoremap <BS> :nohlsearch<cr>

  " for browsing the input history
  cnoremap <c-n> <down>
  cnoremap <c-p> <up>

  nmap - <Plug>VinegarVerticalSplitUp

  " Select just pasted text.
  nnoremap <leader>V V`]

  nnoremap <silent><leader>r :<c-u>Denite register<cr>

  nnoremap <leader>qq :SmartClose<cr>

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

  nnoremap <leader>o <c-w><Bar><c-w>_<cr>
  nnoremap <leader>= <c-w>=

  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endfunction

augroup bindings
  autocmd!
  autocmd VimEnter * call s:general_bindings()
  autocmd FileType haskell,lhaskell call s:haskell_bindings()
  autocmd FileType python,python.django call s:python_bindings()
  autocmd FileType go call s:go_bindings()
  autocmd FileType rust call s:rust_bindings()
augroup END
