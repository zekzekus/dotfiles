" Changing Leader Key
nnoremap <Space> <nop>
let mapleader = "\<Space>"
let localleader = "\\"

function! s:unite_bindings()
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
  nnoremap <silent> <leader>md :call jedi#goto()<cr>
  nnoremap <silent> <leader>mg :call jedi#goto_assignments()<cr>
  nnoremap <silent> <leader>mr :call jedi#rename()<cr>
  nnoremap <silent> <leader>mn :call jedi#usages()<cr>
  nnoremap <silent> <leader>mV :VirtualEnvActivate 
endfunction

function! s:haskell_bindings()
  nnoremap <leader>mt :GhcModType<cr>
  nnoremap <leader>mc :GhcModTypeClear<cr>
  nnoremap <leader>mi :GhcModInfoPreview<cr>
  nmap <leader>mcc :call VimuxRunCommand("stack build")<cr>
  nmap <leader>mct :call VimuxRunCommand("stack test")<cr>
endfunction

function! s:go_bindings()
  nmap <leader>mt <Plug>(go-info)
  nmap <leader>mi <Plug>(go-info)
  nmap <leader>mr <Plug>(go-rename)
  nmap <leader>mcc :call VimuxRunCommand("go build")<cr>
  nmap <leader>mcr :call VimuxRunCommand("go run")<cr>
  nmap <leader>mct :call VimuxRunCommand("go test")<cr>
endfunction

function! s:rust_bindings()
  nmap <buffer><leader>md <Plug>RacerGoToDefinitionDrect
  nmap <buffer><leader>mD <Plug>RacerGoToDefinitionSplit
  nmap <buffer><leader>mi <Plug>RacerShowDocumentation
  nnoremap <leader>mcc :call VimuxRunCommand("cargo build")<cr>
  nnoremap <leader>mcr :call VimuxRunCommand("cargo run")<cr>
  nnoremap <leader>mct :call VimuxRunCommand("cargo test")<cr>
endfunction

function! s:general_bindings()
  " vim handles long lines nicely with these
  nnoremap j gj
  nnoremap k gk

  " file
  nmap <leader>ft <ESC>:TagbarToggle<cr>
  " to remove white space from a file.
  nnoremap <leader>fW :%s/\s\+$//<cr>:let @/=''<CR>

  nnoremap <silent> <leader>ff :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
  nnoremap <silent> <leader>fg :<C-u>Unite -toggle -auto-resize -buffer-name=gitfiles file_rec/git:<cr><c-u>
  nnoremap <silent> <leader>fj :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<cr>

  " buffer
  nnoremap <silent> <leader>bb :<C-u>Unite -auto-resize -buffer-name=buffers buffer<cr>
  nnoremap <leader><tab> :b#<CR>

  " search
  nnoremap / /\v
  vnoremap / /\v
  nnoremap n nzzzv
  nnoremap N Nzzzv
  nmap <silent> <leader>sD <Plug>DashGlobalSearch
  nmap <silent> <leader>sd <Plug>DashSearch
  nnoremap <leader>ss :Grepper<cr>
  nnoremap <leader>sn :noh<cr>
  nmap sg  <plug>(GrepperOperator)
  xmap sg  <plug>(GrepperOperator)
  nnoremap <leader>* :Grepper -cword -noprompt<cr>

  " for browsing the input history
  cnoremap <c-n> <down>
  cnoremap <c-p> <up>

  " misc
  nnoremap <tab> %
  vnoremap <tab> %

  " Select just pasted text.
  nnoremap <leader>V V`]

  " vimux
  nmap <leader>vp :VimuxPromptCommand<cr>
  nmap <leader>vr :VimuxRunLastCommand<cr>
  nmap <leader>vi :VimuxInspectRunner<cr>
  nmap <leader>vt :VimuxTogglePane<cr>
  nmap <leader>vq :VimuxCloseRunner<cr>
  nmap <leader>vc :VimuxInterruptRunner<cr>
  nmap <leader>vz :call VimuxZoomRunner()<cr>
  nmap <leader>vj :call VimuxScrollDownInspect()<cr>
  nmap <leader>vk :call VimuxScrollUpInspect()<cr>

  " unite bindings
  nnoremap <silent> <leader>r :<C-u>Unite -buffer-name=registers register<cr>
  nnoremap <silent> <leader>l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
  nnoremap <silent> <leader>/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
  nnoremap <silent> <leader>y :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>

  " quit
  nnoremap <silent><leader>Q :SmartClose<cr>
  vnoremap <silent><leader>Q :SmartClose<cr>
endfunction

augroup bindings
  autocmd!
  autocmd VimEnter * call s:general_bindings()
  autocmd FileType haskell call s:haskell_bindings()
  autocmd FileType python,python.django call s:python_bindings()
  autocmd FileType unite call s:unite_bindings()
  autocmd FileType go call s:go_bindings()
  autocmd FileType rust call s:rust_bindings()
augroup END
