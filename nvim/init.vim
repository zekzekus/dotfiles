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
  autocmd QuickFixCmdPost cgetexpr,cexpr        cwindow
  autocmd User            ProjectionistActivate call zek#custom_projections()
augroup END

set inccommand=split
augroup terminal_au
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END
let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'

let g:netrw_liststyle    = 3
let g:vitality_fix_focus = 0
let g:fzf_preview_window = ''

runtime! keybindings.vim
