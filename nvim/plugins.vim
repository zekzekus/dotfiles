if !has('nvim')
  call plug#begin('~/.cache/plugged_vim')
  Plug 'sjl/vitality.vim'
  Plug 'tpope/vim-sensible'
else
  call plug#begin('~/.cache/plugged_nvim')
endif

" editing
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug 'ihsanturk/neuron.vim'
Plug 'Shougo/junkfile.vim',     {'on': 'JunkfileOpen'}

" navigating
Plug 'tpope/vim-apathy'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose', {'on': 'SmartClose'}
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" vim interface
Plug 'zekzekus/menguless'
Plug 'ajgrf/parchment'
Plug 'arcticicestudio/nord-vim'

" programming
Plug 'neomake/neomake'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dadbod',               {'on': 'DB'}
Plug 'AndrewRadev/linediff.vim',       {'on': 'Linediff'}
Plug 'autozimu/LanguageClient-neovim', {'for': ['haskell', 'rust', 'python', 'javascript', 'ruby'],
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
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
