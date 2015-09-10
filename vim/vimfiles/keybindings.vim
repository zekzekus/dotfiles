nnoremap / /\v
vnoremap / /\v

" vim handles long lines nicely with these
nnoremap j gj
nnoremap k gk

"Changing Leader Key
nnoremap <Space> <nop>
let mapleader = "\<Space>"
let localleader = "\\"

nnoremap <leader>n :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

",W Command to remove white space from a file.
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" ,v Select just pasted text.
nnoremap <leader>V V`]

" For Qicker Escaping between normal and editing mode.
inoremap fd <ESC>

" easy save file
nnoremap <leader>fs :w<CR>

" easy switch to last edited buffer (alternate buffer)
nnoremap <leader><tab> :b#<CR>

" make word uppercase and continue editing
inoremap <c-u> <esc>gUiw`]a
" make word under the cursor uppercase
nnoremap <c-u> gUiw

map <F5> :call ToggleBg()<CR>

nnoremap <leader>qp :pclose<cr>:cclose<cr>:helpclose<cr>
nnoremap <leader>qq :qa<cr>
nnoremap <leader>bd :bd<cr>

" Tagbar key bindings."
nmap <leader>T <ESC>:TagbarToggle<cr>

" gundo settings
nnoremap <leader>G :GundoToggle<CR>

" fugitive
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>

" dash.vim cinfiguration
:nmap <silent> <leader>S <Plug>DashGlobalSearch
:nmap <silent> <leader>s <Plug>DashSearch

nnoremap <silent> <leader>ff :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
nnoremap <silent> <leader>fg :<C-u>Unite -toggle -auto-resize -buffer-name=gitfiles file_rec/git:<cr><c-u>

nnoremap <silent> <leader>fe :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> <leader>h :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> <leader>r :<C-u>Unite -buffer-name=registers register<cr>
nnoremap <silent> <leader>l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> <leader>bB :<C-u>Unite -quick-match buffer<cr>
nnoremap <silent> <leader>bb :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> <leader>/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>

nnoremap <silent> <leader>y :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>
nnoremap <silent> <leader>H :<C-u>Unite -auto-resize -buffer-name=help help<cr>
nnoremap <silent> <leader>a :<C-u>Unite -auto-preview -no-start-insert -buffer-name=airline airline_themes<cr>
nnoremap <silent> <leader>c :<C-u>Unite -auto-preview -no-start-insert -buffer-name=colorschemes colorscheme<cr>

nnoremap <silent> <leader>fj :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<cr>

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ neocomplete#start_manual_complete()
function! s:check_back_space()
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! s:unite_settings()
  nmap <buffer> Q <plug>(unite_exit)
  nmap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-r>   <Plug>(unite_redraw)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
endfunction

function! s:python_bindings()
  nnoremap <silent> <leader>mr :call jedi#rename()<cr>
  nnoremap <silent> <leader>mn :call jedi#usages()<cr>
  nnoremap <silent> <leader>md :call jedi#goto_definitions()<cr>
  nnoremap <silent> <leader>mg :call jedi#goto_assignments()<cr>
  nnoremap <silent> <leader>mV :VirtualEnvActivate 

endfunction

function! s:haskell_bindings()
  nnoremap <leader>mt :HdevtoolsType<cr>
  nnoremap <leader>mc :HdevtoolsClear<cr>
  nnoremap <leader>mi :HdevtoolsInfo<cr>
endfunction

function! s:go_bindings()
  nmap <leader>mt <Plug>(go-info)
  nmap <leader>mi <Plug>(go-info)
  nmap <leader>md <Plug>(go-def)
  nmap <leader>mr <Plug>(go-rename)
  nmap <leader>mcc :call VimuxRunCommand("go build")<cr>
  nmap <leader>mcr :call VimuxRunCommand("go run")<cr>
  nmap <leader>mct :call VimuxRunCommand("go test")<cr>
endfunction

function! s:rust_bindings()
  nnoremap <leader>mcc :call VimuxRunCommand("cargo build")<cr>
  nnoremap <leader>mcr :call VimuxRunCommand("cargo run")<cr>
  nnoremap <leader>mct :call VimuxRunCommand("cargo test")<cr>
  nnoremap <leader>md :call racer#JumpToDefinition()<CR>
endfunction

function! s:windows_bindings()
  nnoremap <leader>wm :only<CR> " window-maximize
endfunction

function! s:vimux_bindings()
  nmap <leader>vp :VimuxPromptCommand<cr>
  nmap <leader>vr :VimuxRunLastCommand<cr>
  nmap <leader>vi :VimuxInspectRunner<cr>
  nmap <leader>vt :VimuxTogglePane<cr>
  nmap <leader>vq :VimuxCloseRunner<cr>
  nmap <leader>vc :VimuxInterruptRunner<cr>
  nmap <leader>vz :call VimuxZoomRunner()<cr>
  nmap <leader>vj :call VimuxScrollDownInspect()<cr>
  nmap <leader>vk :call VimuxScrollUpInspect()<cr>
endfunction


augroup bindings
  autocmd!
  autocmd FileType * call s:windows_bindings()
  autocmd FileType * call s:vimux_bindings()
  autocmd FileType haskell call s:haskell_bindings()
  autocmd FileType python,python.django call s:python_bindings()
  autocmd FileType unite call s:unite_settings()
  autocmd FileType go call s:go_bindings()
  autocmd FileType rust call s:rust_bindings()
augroup END


" a sketch of mnemonic keybinding namespacing
" - File
" -- Find (ff)
" -- Junk (fj)
" - Buffer
" -- Find (bb)
" -- Delete (bd)
" - Git
" -- Status (gs)
" -- Diff (gd)
" - Quit
" -- Quit All (qq)
" -- Quit Preview, help etc. (qp)
" -- Save and Quit
" - Search
" - Window
