" ========== Vim Basic Settings ============="
scriptencoding utf-8
source ~/.config/nvim/plugins.vim

set modelines=0
set mouse=a
set updatetime=1000

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
set shortmess+=c

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
set wildignore+=vendor

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
  " temporary solution to workaround slow startup
  if has('mac')
    let g:clipboard = {
              \   'name': 'mac-custom',
              \   'copy': {
              \      '+': 'pbcopy',
              \      '*': 'pbcopy',
              \    },
              \   'paste': {
              \      '+': 'pbpaste',
              \      '*': 'pbpaste',
              \   },
              \ }
  endif
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

let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
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

let g:intero_type_on_hover = 1
function! Haskell_editing_tabular()
  AddTabularPattern! colon                  /^[^:]*\zs:/
  AddTabularPattern! haskell_bindings       /^[^=]*\zs=\ze[^[:punct:]]/
  AddTabularPattern! haskell_comments       /--.*/l2
  AddTabularPattern! haskell_do_arrows      / \(<-\|←\) /l0r0
  AddTabularPattern! haskell_imports        /^[^(]*\zs(.*\|\<as\>.*/
  AddTabularPattern! haskell_pattern_arrows / \(->\|→\) /l0r0
  AddTabularPattern! haskell_types          / \(::\|∷\) /l0r0
endfunction
let g:haskell_classic_highlighting = 1
let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2
let g:haskell_indent_case_alternative = 1
let g:cabal_indent_section = 2

augroup au_plugins
  autocmd!
  autocmd FileType haskell call Haskell_editing_tabular()
  autocmd FileType haskell setlocal formatprg=format-haskell expandtab
augroup end

if filereadable(glob('~/.config/nvim/keybindings.vim'))
  source ~/.config/nvim/keybindings.vim
endif
