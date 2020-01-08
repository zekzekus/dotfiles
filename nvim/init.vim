runtime! plugins.vim

set modelines=0
set mouse=a
set updatetime=500
set number

set hidden
set splitbelow
set splitright

set cursorline

set ignorecase
set smartcase
set hlsearch
set incsearch

set showmatch

set completeopt=menuone,noinsert,noselect
set shortmess+=c

set showbreak=↪\ 
set listchars=tab:\│\ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅

set foldmethod=indent
set foldlevel=99

set backupskip=/tmp/*,/private/tmp/*"

set wildmode=longest:full,full
set wildignorecase

set directory=~/.nvimtmp
set undofile
set undodir=~/.nvimtmp

set termguicolors
colorscheme nord

augroup general_au
  autocmd!
  autocmd VimResized * :wincmd =
  autocmd QuickFixCmdPost cgetexpr cwindow
augroup END

let g:netrw_liststyle=3

runtime! plugin/sensible.vim

set noruler
set noshowcmd
set statusline=%w%q
set statusline+=\ 【\ %f%M%R%H\ 】
set statusline+=%=
set statusline+=%{(&paste==0?'':'〖P〗')}
set statusline+=\ 《\ 
set statusline+=%Y
set statusline+=\ 》\ 
set statusline+=〔%l\ ↕\ %L\ ↕\ %c〕
set statusline+=\ ┇\ 
set statusline+=%%%p
set statusline+=\ ┇\ 
set statusline+=%{zek#listinfos()}

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ \"!tags\"

if has('nvim')
  set inccommand=nosplit
  set clipboard+=unnamedplus
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

packadd cfilter

" ========== Plugin Settings =========="
let g:smartclose_set_default_mapping = 0

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ 'haskell': ['ghcide', '--lsp'],
    \ 'go': ['gopls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'scala': ['metals-vim'],
    \ 'ruby': ['bundle', 'exec', 'solargraph', 'stdio'],
    \ }
let g:LanguageClient_diagnosticsList = 'location'
let g:LanguageClient_useVirtualText = 'No'
let g:LanguageClient_useFloatingHover = 0
let g:LanguageClient_usePopupHover = 0
let g:LanguageClient_diagnosticsMaxSeverity = 'Warning'

let g:vista#renderer#enable_icon = 0
let g:vista_sidebar_width = 40
let g:vista_echo_cursor_strategy = "echo" 

let g:CoolTotalMatches = 1

runtime! keybindings.vim
