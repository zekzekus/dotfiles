runtime! plugins.vim

set modelines=0
set mouse=a
set updatetime=500
set number

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

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
call zek#set_background()
colorscheme two-firewatch
highlight CursorLine cterm=none

augroup general_au
  autocmd!
  autocmd VimResized * :wincmd =
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd ColorScheme * highlight CursorLine cterm=none
augroup END

let g:netrw_liststyle=3

runtime! plugin/sensible.vim

set noruler
set noshowcmd
set statusline=%w%q
set statusline+=\ ⋮\ %f%M%R%H\ ⋮
set statusline+=%=
set statusline+=%{(&paste==0?'':'[P]')}
set statusline+=\ ⋮\ 
set statusline+=%y
set statusline+=\ ⋮\ 
set statusline+=(%l/%L/%c)
set statusline+=\ ⋮\ 
set statusline+=%%%p
set statusline+=\ ⋮\ 
set statusline+=%{zek#listinfos()}

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

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

" ========== Plugin Settings =========="
let g:smartclose_set_default_mapping = 0

if has('nvim')
  let g:fzf_layout = { 'window': 'call zek#float_fzf()' }
endif

let g:vista#renderer#enable_icon = 0
let g:vista_sidebar_width = 40
let g:vista_echo_cursor_strategy = "floating_win" 

let g:coc_node_path = $HOME . '/.nodenv/versions/11.11.0/bin/node'
let g:coc_global_extensions = [
      \ "coc-snippets", "coc-omni", "coc-conjure", "coc-yaml", "coc-tsserver",
      \ "coc-rls", "coc-pyls", "coc-json", "coc-html", "coc-css",
      \]

runtime! keybindings.vim
