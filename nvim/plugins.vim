if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
else
  call plug#begin('~/.config/nvim/plugged')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" programming
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog', {'on': ['Flog', 'Flogsplit']}
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ 'for': ['python', 'haskell', 'rust', 'javascript', 'typescript', 'scala', 'go', 'ruby'],
    \ }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Plug 'tpope/vim-projectionist'

" editing
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'farmergreg/vim-lastplace'
Plug 'Shougo/junkfile.vim'

" navigating
Plug 'tpope/vim-vinegar', {'on': '<Plug>VinegarVerticalSplitUp'}
Plug 'liuchengxu/vista.vim', {'on': 'Vista'}
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose', {'on': 'SmartClose'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" python
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

" dart
Plug 'dart-lang/dart-vim-plugin', {'for': 'dart'}

" javascript / JSON
Plug 'tpope/vim-jdaddy', {'for': 'json'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}

" haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}

" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}

" typescript
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'neoclide/coc.nvim', {'for': 'typescript', 'branch': 'release'}

" ruby
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'tpope/vim-bundler', {'for': 'ruby'}
Plug 'tpope/vim-rake', {'for': 'ruby'}
Plug 'tpope/vim-rbenv', {'for': 'ruby'}

" misc
Plug 'diepm/vim-rest-console', {'for': 'rest'}

Plug 'embear/vim-localvimrc'

call plug#end()
