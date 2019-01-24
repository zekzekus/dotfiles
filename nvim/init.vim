scriptencoding utf-8
runtime! plugins.vim

set modelines=0
set mouse=a
set updatetime=500
set autowrite
set autoread

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set hidden
set visualbell
set splitbelow
set splitright

set cursorline
set number
set norelativenumber

set lazyredraw

set ignorecase
set smartcase
set hlsearch
set incsearch

set showmatch
set matchtime=3

set nowrap
set textwidth=79
set colorcolumn=+1

set completeopt=menuone,noinsert,noselect
set shortmess+=c

set showbreak=↪\ 
set listchars=tab:\│\ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅

set foldmethod=indent
set foldlevel=99

set backupskip=/tmp/*,/private/tmp/*"

set wildmode=longest:full,full
set wildignorecase
set wildignore+=*.pyc

set directory=~/.nvimtmp
set undofile
set undodir=~/.nvimtmp

set termguicolors
if $ITERM_PROFILE =~? 'dark'
  set background=dark
else
  set background=light
endif
let g:two_firewatch_italics=1
colorscheme two-firewatch
if !has('nvim')
  highlight CursorLine cterm=none
endif

augroup general_au
  autocmd!

  autocmd VimResized * :wincmd =
  autocmd InsertEnter * setlocal list
  autocmd InsertLeave * setlocal nolist
augroup END

let g:netrw_liststyle=3

runtime! plugin/sensible.vim
set showmode
set noshowcmd
set laststatus=2
set statusline=
set statusline+=%w
set statusline+=%q
set statusline+=\ »\ %F%m\ «
set statusline+=%=
set statusline+=%{(&paste==0?'':'[P]')}
set statusline+=[%H
set statusline+=%Y
set statusline+=%R]
set statusline+=(%l
set statusline+=/
set statusline+=%L)
set statusline+=%%%p
set noruler

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

if has('nvim')
  set inccommand=nosplit
  set clipboard+=unnamedplus
  " temporary solution to workaround slow startup
  if has('mac')
    let g:clipboard = {
              \   'name': 'mac-custom',
              \   'copy': {
              \      '+': 'pbcopy',
              \      '*': 'pbcopy',
              \    },
              \   'paste': {
              \      '+': 'pbpaste',
              \      '*': 'pbpaste',
              \   },
              \ }
  endif
  augroup terminal_au
    autocmd!

    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END

  let g:python_host_skip_check=1
  let g:python3_host_skip_check=1
  let g:python_host_prog = $HOME . '/.virtualenvs/neovim2/bin/python'
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'
else
  set ttyfast
  set clipboard+=unnamed
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" ========== Plugin Settings =========="
let g:smartclose_set_default_mapping = 0

call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#option('_', 'highlight_mode_insert', 'Underlined')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'None')
call denite#custom#option('_', 'source_names', 'short')

let g:LanguageClient_serverCommands = {
    \ 'rust':           ['rls'],
    \ 'python':         ['pyls'],
    \ 'haskell':        ['stack', 'exec', 'hie', '--', '--lsp'],
    \ }
let g:LanguageClient_diagnosticsEnable = 1

runtime! keybindings.vim
