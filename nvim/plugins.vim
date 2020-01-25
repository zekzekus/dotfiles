if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
else
  call plug#begin('~/.config/nvim/plugged')
endif

" editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}

" navigating
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'

" vim interface
Plug 'seesleestak/duo-mini'

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
    \ 'for': ['python', 'haskell', 'rust', 'javascript', 'scala', 'go', 'ruby'],
    \ }

" javascript / JSON
Plug 'tpope/vim-jdaddy', {'for': 'json'}

" clojure
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'tpope/vim-salve', {'for': 'clojure'}
Plug 'eraserhd/parinfer-rust', {'for': 'clojure', 'do': 'cargo build --release'}

" ruby
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'tpope/vim-rake', {'for': 'ruby'}
Plug 'tpope/vim-bundler', {'for': 'ruby'}

call plug#end()
