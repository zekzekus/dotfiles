" buffer local options
setlocal nowrap

" plugin settings
let g:clj_fmt_autosave = 0

" keybindings
nnoremap <silent><buffer>gd <Plug>FireplaceDjump
nnoremap <silent><buffer>gD <Plug>FireplaceDsplit
nmap <silent><buffer>K <Plug>FireplaceK
nnoremap <silent><buffer>gi <Plug>FireplaceSource
