" ========== Vim Basic Settings ============="
scriptencoding utf-8
source ~/.config/nvim/plugins.vim

set modelines=0

"TAB settings.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" More Common Settings.
set showmode
set showcmd
set hidden
set visualbell

set ttyfast

set regexpengine=1
set synmaxcol=300
set nocursorcolumn
set nocursorline

set number
set norelativenumber

set undofile
set lazyredraw
set matchtime=3

"Settings for Searching and Moving
set ignorecase
set smartcase
set showmatch
set hlsearch

" Make Vim to handle long lines nicely.
set wrap
set textwidth=79
set colorcolumn=79

set completeopt=menu,noinsert,noselect

" To  show special characters in Vim
set listchars=tab:▸\ ,eol:¬

" enable folding
set foldmethod=indent
set foldlevel=99

" Set title to window
set title

" Make pasting done without any indentation break."
set pastetoggle=<F3>

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Wildmenu completion "
set wildmode=longest:full,full
set wildignore+=.hg,.git,.svn " Version Controls"
set wildignore+=*.aux,*.out,*.toc "Latex Indermediate files"
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg "Binary Imgs"
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest "Compiled Object files"
set wildignore+=*.spl "Compiled speolling world list"
set wildignore+=*.sw? "Vim swap files"
set wildignore+=*.DS_Store "OSX SHIT"
set wildignore+=*.luac "Lua byte code"
set wildignore+=*.pyc "Python Object codes"
set wildignore+=*.orig "Merge resolution files"
set wildignore+=*.beam
set wildignore+=build
set wildignore+=static
set wildignore+=tmp
set wildignore+=**/node_modules/**
set wildignore+=*.class
set wildignore+=.stack-work
set wildignore+=**/bower_components/**

set path+=**

set directory=~/.nvimtmp
set undodir=~/.nvimtmp

set suffixesadd+=.html
set suffixesadd+=.vim
set suffixesadd+=.py
set suffixesadd+=.rs
set suffixesadd+=.hs
set suffixesadd+=.md
set suffixesadd+=.txt
set suffixesadd+=.todo

" Removing scrollbars
if has('gui_running')
  set guitablabel=%-0.12t%M
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
  set guioptions+=a
  set guioptions-=m
  set guifont=Fira\ Code:h12
endif

" Special Settings for Consoles
" if !has("gui_running")
"   set t_Co=256
" endif

set termguicolors
if $ITERM_PROFILE =~? 'light'
  colorscheme solarized8_light
elseif $ITERM_PROFILE =~? 'acme'
  colorscheme nofrils-acme
elseif $ITERM_PROFILE =~? 'sepia'
  colorscheme nofrils-sepia
else
  colorscheme solarized8_dark
endif

syntax sync minlines=256
highlight clear VertSplit

" make vim to autoresize its windows after resize
augroup file_operation
  autocmd!
  autocmd VimResized * :wincmd =
augroup END

" Make Sure that Vim returns to the same line when we reopen a file"
function! FindLatestPosition()
  if &filetype =~? 'gitcommit'
    return
  endif
  if line("'\"") > 0 && line("'\"") <= line('$') |
    execute 'normal! g`"zvzz' |
  endif
endfunction
augroup line_return
  autocmd!
  autocmd BufReadPost * call FindLatestPosition()
augroup END

augroup programming_au
  autocmd!
  autocmd FileType ruby,vim,jade,stylus setlocal ts=2 sts=2 sw=2
  autocmd FileType javascript,lua setlocal ts=2 sts=2 sw=2
  autocmd FileType html,htmldjango setlocal nowrap ts=2 sts=2 sw=2
  autocmd FileType snippet,snippets setlocalocal noexpandtab
  autocmd BufEnter *.rss,*.atom,*.odrl setf xml
  autocmd BufEnter *.pkb,*.pks,*.tpb,*.tps,*.prc set ft=plsql
  autocmd BufEnter plsql setlocal ts=2 sts=2 sw=2
  autocmd BufEnter volofile setf javascript
  " autocmd FileType python set ft=python.django " For SnipMate
  autocmd FileType html set ft=htmldjango " For SnipMate
augroup END

let g:netrw_liststyle=3

" ========== Plugin Settings =========="

" neomake syntax checker settings
augroup neomake_au
  autocmd!
  autocmd BufWritePost *.hs Neomake
  autocmd BufWritePost *.py Neomake
  autocmd BufWritePost *.rs Neomake
  autocmd BufWritePost *.go Neomake
  autocmd BufWritePost *.vim Neomake
  autocmd BufWritePost *.rb Neomake
augroup END

" snipmate trigger key modified because conflicts with youcompleteme
let g:UltiSnipsExpandTrigger='<C-j>'
let g:UltiSnipsJumpForwardTrigger='<c-b>'
let g:UltiSnipsJumpBackwardTrigger='<c-z>'

" unite
let s:cache_dir = '~/.nvimtmp/cache'
function! s:get_cache_dir(suffix)
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction
" call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])

call unite#custom#profile('default', 'context', {
      \ 'start_insert': 1,
      \ 'short_source_names': 1,
      \ 'direction': 'botright',
      \ 'prompt': '> ',
      \ 'cursor_line_highlight': 'TabLine',
      \ 'winheight': 10,
      \ })

let g:unite_data_directory=s:get_cache_dir('unite')
let g:unite_source_history_yank_enable=1

let g:junkfile#directory=s:get_cache_dir('junk')

" jedi-vim
let g:jedi#auto_vim_configuration = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures = 0

augroup omni
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,htmldjango,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
augroup END

let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'T:types,type definitions',
        \'f:functions,function definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'m:modules,module names',
        \'c:consts,static constants',
        \'t:traits,traits',
        \'i:impls,trait implementations',
    \]
    \}

" smartclose
let g:smartclose_set_default_mapping = 0

" supertab
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-n>'

if has('nvim')
  let g:python_host_skip_check=1
  let g:python3_host_skip_check=1
  let g:python_host_prog = $HOME . '/.virtualenvs/neovim2/bin/python'
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'

  set clipboard+=unnamedplus

  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

  let g:jedi#auto_initialization = 0
  let g:jedi#completions_enabled = 0
  let g:deoplete#enable_at_startup = 1
else
  let g:jedi#auto_initialization = 1
  let g:jedi#popup_on_dot = 0

  set clipboard+=unnamed
  set mouse=a

  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let g:fzf_command_prefix = 'FF'
let g:fzf_layout = { 'down': '~20%' }

if filereadable(glob('~/.config/nvim/keybindings.vim'))
  source ~/.config/nvim/keybindings.vim
endif
