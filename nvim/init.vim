runtime! plugins.vim

set shell=/usr/bin/env\ bash
set modelines=0
set mouse=a
set updatetime=500

set hidden
set splitbelow
set splitright

set number
set cursorline

set ignorecase
set smartcase
set hlsearch

set completeopt=menuone,noinsert,noselect

set showbreak=↪\ 
set listchars=tab:\│\ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅
set errorformat+=%f

set foldmethod=indent
set foldlevel=99

set wildignorecase

set directory=~/.nvimtmp
set undofile
set undodir=~/.nvimtmp
set tags+=,.git/tags

set termguicolors
let g:duo_mini_bg = "#2E3440"
colorscheme duo-mini
call zek#my_highlights()

augroup general_au
  autocmd!
  autocmd VimResized * :wincmd =
  autocmd QuickFixCmdPost cgetexpr,cexpr cwindow
  autocmd ColorScheme * call zek#my_highlights()
augroup END

let g:netrw_liststyle=3

runtime! plugin/sensible.vim

set statusline=%w%q
set statusline+=\ 【\ %f%M%R%H\ 】
set statusline+=%=
set statusline+=%{(&paste==0?'':'〖P〗')}
set statusline+=\ 《\ %Y\ 》
set statusline+=〔%l\ ↕\ %L\ ↕\ %c〕
set statusline+=\ ┇\ %%%p\ ┇
set statusline+=%{zek#listinfos()}

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ \"!tags\"

if has('nvim')
  set inccommand=split
  set clipboard+=unnamedplus
  augroup terminal_au
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END

  let g:python_host_prog = $HOME . '/.virtualenvs/neovim2/bin/python'
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'
else
  set clipboard+=unnamed
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

packadd cfilter

" ========== Plugin Settings =========="
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

augroup custom_au
  autocmd!
  autocmd User ProjectionistActivate call zek#custom_projections()
augroup END

runtime! keybindings.vim
