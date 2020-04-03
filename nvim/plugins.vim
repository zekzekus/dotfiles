if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'sjl/vitality.vim'
  Plug 'tpope/vim-sensible'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
else
  call plug#begin('~/.config/nvim/plugged')
endif

" editing
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/neosnippet.vim', {'do': function('zek#updateremote')}
Plug 'Shougo/neosnippet-snippets'
Plug 'godlygeek/tabular',   {'on': 'Tabularize'}
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}

" navigating
Plug 'junegunn/fzf.vim'
Plug 'szw/vim-smartclose'
Plug '/usr/local/opt/fzf'
Plug 'tpope/vim-unimpaired'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'

" vim interface
Plug 'seesleestak/duo-mini'

" programming
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-projectionist'
Plug 'lifepillar/vim-mucomplete'
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do':     'bash install.sh',
      \ 'for':    ['python', 'haskell', 'rust', 'go', 'ruby', 'javascript'],
      \ }

Plug 'tpope/vim-jdaddy', {'for': 'json'}

Plug 'guns/vim-sexp',                              {'for': 'clojure'}
Plug 'tpope/vim-salve',                            {'for': 'clojure'}
Plug 'tpope/vim-fireplace',                        {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}
Plug 'eraserhd/parinfer-rust',                     {'for': 'clojure', 'do': 'cargo build --release'}

Plug 'tpope/vim-rake',    {'for': 'ruby'}
Plug 'tpope/vim-rails',   {'for': 'ruby'}
Plug 'tpope/vim-bundler', {'for': 'ruby'}

call plug#end()
