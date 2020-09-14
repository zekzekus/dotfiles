set shell=/usr/bin/env\ bash

runtime! plugins.vim
packadd cfilter

set mouse=a
set number
set hidden
set signcolumn=number
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
set errorformat+=%f
set undofile
set tags+=,.git/tags
set undodir=~/.nvimtmp
set directory=~/.nvimtmp
set completeopt=menuone,noinsert,noselect
set showbreak=↪\ 
set listchars=tab:\│\ ,eol:↵,nbsp:␣,trail:⋅,extends:⟩,precedes:⟨,space:⋅
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ \"!tags\"\ --hidden\ --glob\ \"!.git\"

set statusline=%w%q
set statusline+=\ 【\ %f%M%R%H\ 】
set statusline+=%=
set statusline+=%{(&paste==0?'':'〖P〗')}
set statusline+=\ 《\ %Y\ 》
set statusline+=〔%l\ ↕\ %L\ ↕\ %c〕
set statusline+=\ ┇\ %%%p\ ┇
set statusline+=\ %{zek#listinfos()}

set termguicolors
call zek#set_colorscheme()

let g:zek_has_replied = v:false
augroup general_au
  autocmd!
  autocmd VimResized      *                     :wincmd =
  autocmd ColorScheme     *                     call zek#post_colorscheme()
  autocmd CmdlineLeave    :                     call zek#autoreply()
  autocmd QuickFixCmdPost cgetexpr,cexpr        copen
  autocmd User            ProjectionistActivate call zek#custom_projections()
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
  let &t_ZH = "\e[3m"
  let &t_ZR = "\e[23m"
endif

let g:netrw_liststyle    = 3
let g:vitality_fix_focus = 0
let g:fzf_preview_window = ''

let g:neomake_virtualtext_current_error = 0
let g:neomake_rust_enabled_makers       = []
let g:neomake_javascript_enabled_makers = []
let g:neomake_python_enabled_makers     = []
let g:neomake_haskell_enabled_makers    = []
let g:neomake_clojure_enabled_makers    = ['kondo']
let g:neomake_clojure_kondo_maker       = {
      \ 'exe': 'clj-kondo',
      \ 'args': ['--config', '.clj-kondo/config.edn', '--lint', '%'],
      \ 'errorformat': '%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m',
      \ }
call neomake#configure#automake('nrwi', 500)

let g:LanguageClient_useFloatingHover = 0
let g:LanguageClient_usePopupHover = 0
let g:LanguageClient_fzfContextMenu = 1
let g:LanguageClient_useVirtualText = 'No'
let g:LanguageClient_serverCommands = {
    \ 'rust':       ['rustup', 'run', 'stable', 'rls'],
    \ 'haskell':    ['haskell-language-server-wrapper', '--lsp'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'python':     ['pyls'],
    \ }


runtime! keybindings.vim
