" ========== Vim Basic Settings ============="
scriptencoding utf-8
source ~/.config/nvim/plugins.vim

set modelines=0
set mouse=a

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set showcmd
set hidden
set visualbell
set splitbelow
set splitright

set regexpengine=1
set synmaxcol=300
set cursorline

set number
set norelativenumber

set undofile
set lazyredraw
set matchtime=3

set ignorecase
set smartcase
set showmatch
set hlsearch
set incsearch

set colorcolumn=79

set completeopt=menuone,noinsert,noselect

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

set path=.,**

set directory=~/.nvimtmp
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

set termguicolors
if $ITERM_PROFILE =~? 'light'
  set background=light
else
  set background=dark
endif
colorscheme off

syntax sync minlines=256

augroup general_au
  autocmd!
  autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 keywordprg=:help
  autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

  autocmd VimResized * :wincmd =
augroup END

let g:netrw_liststyle=3

let g:modmap={
    \ 'n'  : 'Normal',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

set noshowmode
set laststatus=2
set statusline=
set statusline+=[%{toupper(g:modmap[mode()])}]
set statusline+=[%{fugitive#head(6)}]
set statusline+=%{(&paste==0?'':'[P]')}
set statusline+=[%f]
set statusline+=%m
set statusline+=%r
set statusline+=%h
set statusline+=%w
set statusline+=%q
set statusline+=%=
" set statusline+=[%{substitute(getcwd(),expand('~'),'~','g')}]
set statusline+=%y
set statusline+=[%{(&fenc!=''?&fenc:&enc)}]\[%{&ff}]
set statusline+=[%l
set statusline+=/
set statusline+=%L]
set statusline+=%#ErrorMsg#%{neomake#statusline#LoclistStatus()}

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

if has('nvim')
  set inccommand=nosplit
  set clipboard+=unnamedplus

  augroup terminal_au
    autocmd!
    autocmd TermOpen * setlocal nonumber
  augroup END
else
  set ttyfast
  set clipboard+=unnamed
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

let g:python_host_skip_check=1
let g:python3_host_skip_check=1
let g:python_host_prog = $HOME . '/.virtualenvs/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.virtualenvs/neovim3/bin/python'

let s:cache_dir = '~/.nvimtmp/cache'
function! s:get_cache_dir(suffix)
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction

" ========== Plugin Settings =========="
call neomake#configure#automake({
\ 'TextChanged': {},
\ 'InsertLeave': {},
\ 'BufWritePost': {'delay': 0},
\ 'BufWinEnter': {},
\ }, 500)
let g:neomake_go_enabled_makers = ['go']

let g:UltiSnipsExpandTrigger='<C-j>'
let g:UltiSnipsListSnippets = '<c-w>'
let g:UltiSnipsJumpForwardTrigger='<c-b>'
let g:UltiSnipsJumpBackwardTrigger='<c-z>'

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
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:smartclose_set_default_mapping = 0

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#show_call_signatures = 0
let g:jedi#completions_enabled = 0

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

let g:racer_experimental_completer = 1

if filereadable(glob('~/.config/nvim/keybindings.vim'))
  source ~/.config/nvim/keybindings.vim
endif
