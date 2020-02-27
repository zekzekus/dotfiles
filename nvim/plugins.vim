if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
else
  call plug#begin('~/.config/nvim/plugged')
endif

" editing
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}

" navigating
Plug 'tpope/vim-unimpaired'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose'

" vim interface
Plug 'shofel/vim-two-firewatch'

" programming
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dadbod'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ 'for': ['python', 'haskell', 'rust', 'go', 'ruby'],
    \ }

Plug 'tpope/vim-jdaddy', {'for': 'json'}

Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'tpope/vim-salve', {'for': 'clojure'}
Plug 'eraserhd/parinfer-rust', {'for': 'clojure', 'do': 'cargo build --release'}
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}

Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'tpope/vim-rake', {'for': 'ruby'}
Plug 'tpope/vim-bundler', {'for': 'ruby'}

call plug#end()
