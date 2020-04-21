if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'sjl/vitality.vim'
  Plug 'tpope/vim-sensible'
else
  call plug#begin('~/.config/nvim/plugged')
endif

" editing
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}

" navigating
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-unimpaired'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf.vim',   {'on': 'Files'}
Plug '/usr/local/opt/fzf', {'on': 'Files'}
Plug 'szw/vim-smartclose', {'on': 'SmartClose'}

" vim interface
Plug 'seesleestak/duo-mini'

" programming
Plug 'neomake/neomake'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dadbod',         {'on': 'DB'}
Plug 'AndrewRadev/linediff.vim', {'on': 'Linediff'}

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
