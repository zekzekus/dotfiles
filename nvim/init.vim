runtime! plugins.vim

set modelines=0
set mouse=a
set updatetime=500

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
set nowrap
set textwidth=79

set completeopt=menuone,noinsert,noselect
set shortmess=flmnrwxoOtTIc

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
let g:two_firewatch_italics=1
if $ITERM_PROFILE =~? 'light'
  colorscheme parchment
else
  colorscheme two-firewatch
endif
highlight CursorLine cterm=none term=none
highlight clear VertSplit

augroup general_au
  autocmd!
  autocmd VimResized * :wincmd =
  autocmd ColorScheme * highlight CursorLine cterm=none term=none
  autocmd ColorScheme * highlight clear VertSplit
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
set statusline+=%{ListInfos()}

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

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#option('_', 'highlight_mode_insert', 'DeniteCursorLine')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'None')
call denite#custom#option('_', 'source_names', 'short')
call denite#custom#option('_', 'split', 'floating')

let g:vista#renderer#enable_icon = 0
let g:vista_sidebar_width = 40

function! ListInfos()
  let qflist = len(getqflist()) > 0 ? 'Q:' . len(getqflist()) . ' ' : ''
  let loclist = len(getloclist(winnr())) > 0 ? 'L:' . len(getloclist(winnr())) : ''
  return qflist . loclist
endfunction

runtime! keybindings.vim
