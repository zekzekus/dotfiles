scriptencoding utf-8
source ~/.config/nvim/plugins.vim

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

set regexpengine=1
set synmaxcol=300
set nocursorline

set number
set relativenumber

set lazyredraw

set ignorecase
set smartcase
set hlsearch
set incsearch

set showmatch
set matchtime=3

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
set wildignore+=.hg,.git,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest
set wildignore+=*.spl
set wildignore+=*.sw?
set wildignore+=*.DS_Store
set wildignore+=*.luac
set wildignore+=*.pyc
set wildignore+=*.orig
set wildignore+=*.beam
set wildignore+=build
set wildignore+=static
set wildignore+=tmp
set wildignore+=**/node_modules/**
set wildignore+=*.class
set wildignore+=.stack-work
set wildignore+=**/bower_components/**
set wildignore+=vendor

set path=.,**

set directory=~/.nvimtmp
set undofile
set undodir=~/.nvimtmp

set suffixesadd+=.html
set suffixesadd+=.vim
set suffixesadd+=.py
set suffixesadd+=.rs
set suffixesadd+=.hs
set suffixesadd+=.md
set suffixesadd+=.yml
set suffixesadd+=.yaml
set suffixesadd+=.toml
set suffixesadd+=.cabal
set suffixesadd+=.md
set suffixesadd+=.go

set termguicolors
if $ITERM_PROFILE =~? 'light'
  set background=light
else
  set background=dark
endif
colorscheme off
highlight clear VertSplit

syntax sync minlines=256

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

let s:cache_dir = '~/.nvimtmp/cache'
function! s:get_cache_dir(suffix)
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction

" ========== Plugin Settings =========="
call neomake#configure#automake({'TextChanged': {}, 'InsertLeave': {}, 'BufWritePost': {'delay': 0}, 'BufWinEnter': {}, }, 500)
let g:neomake_open_list = 2
let g:neomake_list_height = 5

let g:UltiSnipsExpandTrigger       = '<C-j>'
let g:UltiSnipsListSnippets        = '<c-w>'
let g:UltiSnipsJumpForwardTrigger  = '<c-b>'
let g:UltiSnipsJumpBackwardTrigger = '<c-z>'

let g:smartclose_set_default_mapping = 0

let g:grepper = {}
runtime plugin/grepper.vim
let g:grepper.rg.grepprg .= ' --smart-case'

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

let g:LanguageClient_serverCommands = {
    \ 'rust':       ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
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

if filereadable(glob('~/.config/nvim/keybindings.vim'))
  source ~/.config/nvim/keybindings.vim
endif
