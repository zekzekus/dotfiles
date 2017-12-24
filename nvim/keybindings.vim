nnoremap <Space> <nop>
let g:mapleader = "\<Space>"
let g:maplocalleader = '\'

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
  nnoremap n nzzzv
  nnoremap N Nzzzv
  nnoremap <silent> <leader>/ :<c-u>Denite -auto-preview -vertical-preview grep<cr>
  nnoremap <silent> <leader>* :<c-u>DeniteCursorWord -auto-preview -vertical-preview grep<cr>
  nnoremap <leader>ss :Grepper -tool rg -quickfix -open -switch -nojump -prompt<cr>
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

  nnoremap <leader>mh :call LanguageClient_textDocument_hover()<CR>
  nnoremap <leader>md :call LanguageClient_textDocument_definition()<cr>
  nnoremap <leader>mr :call LanguageClient_textDocument_rename()<cr>
  nnoremap <leader>mn :call LanguageClient_textDocument_references()<cr>
endfunction

augroup bindings
  autocmd!
  autocmd VimEnter * call s:general_bindings()
augroup END
