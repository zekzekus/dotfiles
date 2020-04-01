set shell=/usr/bin/env\ bash

runtime! plugins.vim
packadd cfilter

set mouse=a
set number
set hidden
set cursorline
set nomodeline
set splitbelow
set splitright
set wildignorecase
set ignorecase
set smartcase
set hlsearch
set foldmethod=indent
set foldlevel=99
set undofile
set tags+=,.git/tags
set undodir=~/.nvimtmp
set directory=~/.nvimtmp
set completeopt=menuone,noinsert,noselect
set listchars=tab:\│\ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ \"!tags\"

set termguicolors
call zek#pre_colorscheme()
colorscheme duo-mini
call zek#post_colorscheme()

set statusline=%w%q
set statusline+=\ 【\ %f%M%R%H\ 】
set statusline+=%=
set statusline+=%{(&paste==0?'':'〖P〗')}
set statusline+=\ 《\ %Y\ 》
set statusline+=〔%l\ ↕\ %L\ ↕\ %c〕
set statusline+=\ ┇\ %%%p\ ┇
set statusline+=\ %{zek#listinfos()}

augroup general_au
  autocmd!
  autocmd VimResized * :wincmd =
  autocmd QuickFixCmdPost cgetexpr,cexpr cwindow
  autocmd QuickFixCmdPost lmake lwindow
  autocmd ColorScheme * call zek#post_colorscheme()
  autocmd User ProjectionistActivate call zek#custom_projections()
  autocmd BufWritePost *.clj[s] silent lmake! <afile> | silent redraw!
  autocmd WinEnter * if &filetype =~# '^denite'
    \ |   highlight! link CursorLine Error
    \ | endif
  autocmd WinLeave * if &filetype ==# 'denite'
    \ |   highlight! link CursorLine NONE
    \ | endif
augroup END

if has('nvim')
  set inccommand=split
  augroup terminal_au
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'
else
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
endif

let g:LanguageClient_serverCommands = {
      \ 'javascript': ['javascript-typescript-stdio'],
      \ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \ 'python': ['pyls'],
      \ 'haskell': ['ghcide', '--lsp'],
      \ 'go': ['gopls'],
      \ 'ruby': ['bundle', 'exec', 'solargraph', 'stdio'],
      \ }
let g:LanguageClient_diagnosticsList = 'location'
let g:LanguageClient_useVirtualText = 'No'
let g:LanguageClient_useFloatingHover = 0
let g:LanguageClient_usePopupHover = 0

let g:vitality_fix_focus = 0
let g:netrw_liststyle=3
let g:smartclose_set_default_mapping = 0
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

call denite#custom#option('_', {
  \ 'prompt': '❯',
  \ 'start_filter': 1,
  \ 'smartcase': 1,
  \ 'vertical_preview': 1,
  \ 'highlight_matched_char': 'Underlined',
  \ })
call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])

runtime! keybindings.vim
