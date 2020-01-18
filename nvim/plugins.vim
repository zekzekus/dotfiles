if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
else
  call plug#begin('~/.config/nvim/plugged')
endif

" editing
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}
Plug 'tpope/vim-sleuth'

" navigating
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'

" vim interface
Plug 'arcticicestudio/nord-vim'

" programming
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ 'for': ['python', 'haskell', 'rust', 'javascript', 'scala', 'go', 'ruby'],
    \ }
Plug 'tpope/vim-apathy', {'for': ['c', 'coffee', 'csh', 'desktop', 'dosbatch', 'go', 'javascript', 'lua', 'python', 'scheme', 'sh', 'typescript', 'zsh']}
Plug 'tpope/vim-dadbod'

" javascript / JSON
Plug 'tpope/vim-jdaddy', {'for': 'json'}

" clojure
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'eraserhd/parinfer-rust', {'for': 'clojure', 'do': 'cargo build --release'}
Plug 'tpope/vim-salve', {'for': 'clojure'}

" ruby
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'tpope/vim-rake', {'for': 'ruby'}
Plug 'tpope/vim-bundler', {'for': 'ruby'}

call plug#end()
