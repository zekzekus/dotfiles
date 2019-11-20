if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
else
  call plug#begin('~/.config/nvim/plugged')
endif

Plug 'OrangeT/vim-csharp'

" programming
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog', {'on': ['Flog', 'Flogsplit']}
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ 'for': ['python', 'haskell', 'rust', 'javascript', 'scala', 'go', 'ruby'],
    \ }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dadbod'

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
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

" vim interface
Plug 'seesleestak/duo-mini'
Plug 'ajgrf/parchment'

" python
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

" javascript / JSON
Plug 'tpope/vim-jdaddy', {'for': 'json'}
Plug 'pangloss/vim-javascript', {'for': 'javascript.jsx'}

" haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}

" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}

" clojure
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'eraserhd/parinfer-rust', {'for': 'clojure', 'do': 'cargo build --release'}

" ruby
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'tpope/vim-bundler', {'for': 'ruby'}
Plug 'tpope/vim-rake', {'for': 'ruby'}
Plug 'tpope/vim-rbenv', {'for': 'ruby'}

" misc
Plug 'diepm/vim-rest-console', {'for': 'rest'}

Plug 'embear/vim-localvimrc'

call plug#end()
