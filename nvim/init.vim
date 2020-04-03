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
set showbreak=↪\ 
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
augroup END

if has('nvim')
  set inccommand=split
  augroup terminal_au
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
     \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
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

let g:fzf_preview_window = ''
let g:vitality_fix_focus = 0
let g:netrw_liststyle=3
let g:smartclose_set_default_mapping = 0
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

let g:mucomplete#chains = {}
let g:mucomplete#chains.default  = ['path', 'omni', 'keyn']
let g:mucomplete#chains.vim      = ['path', 'keyn', 'cmd']
let g:mucomplete#always_use_completeopt = 1
let g:mucomplete#cycle_with_trigger = 1

runtime! keybindings.vim
