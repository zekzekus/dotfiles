function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

" programming
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'Shougo/neco-vim', {'for': 'vim'}

" editing
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'szw/vim-smartclose'
Plug 'godlygeek/tabular'
Plug 'farmergreg/vim-lastplace'
Plug 'Shougo/junkfile.vim'

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'yuttie/comfortable-motion.vim'
Plug 'lambdalisue/lista.nvim'
Plug 'Shougo/denite.nvim', {'do': function('DoRemote')}

" vim interface
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'
Plug 'sjl/badwolf'

" python
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'zchee/deoplete-jedi', {'for': 'python'}

" javascript
Plug 'tpope/vim-jdaddy', {'for': 'json'}

" misc
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'sjl/vitality.vim'
Plug 'diepm/vim-rest-console', {'for': 'rest'}

" haskell
Plug 'parsonsmatt/intero-neovim', {'for': 'haskell'}
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'alx741/vim-hindent', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'Twinside/vim-hoogle', {'for': 'haskell'}

" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}

" go lang
Plug 'zchee/deoplete-go', {'for': 'go'}
Plug 'fatih/vim-go', {'for': 'go'}

call plug#end()
