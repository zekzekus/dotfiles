set shell=/usr/bin/env\ bash

runtime! plugins.vim
packadd cfilter

set mouse=a
set number
set hidden
set cursorline
set nomodeline
set nowrap
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
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --glob\ \"!tags\"\ --hidden\ --glob\ \"!.git\"

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
  autocmd ColorScheme * call zek#post_colorscheme()
  autocmd User ProjectionistActivate call zek#custom_projections()
augroup END

if has('nvim')
  set inccommand=split
  augroup terminal_au
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd FileType fzf set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  augroup END
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'
else
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
endif

let g:vitality_fix_focus = 0
let g:neomake_virtualtext_current_error = 0
call neomake#configure#automake('nrwi', 500)
let g:neomake_clojure_enabled_makers = ['kondo']
let g:neomake_clojure_kondo_maker = {
      \ 'exe': 'clj-kondo',
      \ 'args': ['--config', '.clj-kondo/config.edn', '--lint', '%'],
      \ 'errorformat': '%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m',
      \ }
let g:netrw_liststyle=3
let g:smartclose_set_default_mapping = 0
let g:vimwiki_list = [
      \ {'path': '~/Documents/vimwiki/',
      \  'path_html': '~/Documents/vimwiki_html/'} ]

runtime! keybindings.vim
