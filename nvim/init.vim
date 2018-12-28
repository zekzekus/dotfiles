scriptencoding utf-8
runtime plugins.vim

set modelines=0
set mouse=a
set updatetime=1000
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
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

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
set background=dark
colorscheme monotone
highlight clear VertSplit

augroup general_au
  autocmd!

  autocmd VimResized * :wincmd =
augroup END

let g:netrw_liststyle=3

runtime! plugin/sensible.vim
set showmode
set noshowcmd
set laststatus=0
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
call neomake#configure#automake({
      \ 'TextChanged': {},
      \ 'InsertLeave': {},
      \ 'BufWritePost': {'delay': 0},
      \ 'BufWinEnter': {}, },
      \ 500)
let g:neomake_open_list = 0

let g:smartclose_set_default_mapping = 0

let g:grepper = {}
runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' --smart-case'
let g:grepper.quickfix = 0

call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#option('_', 'highlight_mode_insert', 'Underlined')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'None')
call denite#custom#option('_', 'source_names', 'short')

let g:LanguageClient_serverCommands = {
    \ 'rust':       ['rls'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'python':     ['pyls'],
    \ 'haskell':    ['stack', 'exec', 'hie', '--', '--lsp'],
    \ }

let g:deoplete#enable_at_startup = 0
augroup plugins_au
  autocmd!

  autocmd InsertEnter * call deoplete#enable()
augroup END
let g:deoplete#keyword_patterns = {}
let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'

runtime keybindings.vim
