function! DoRemote(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

if has('nvim')
  call plug#begin('~/.config/nvim/plugged')

  Plug 'zchee/deoplete-jedi', {'for': 'python'}
  Plug 'zchee/deoplete-go', {'for': 'go'}
  Plug 'Shougo/neco-vim', {'for': 'vim'}
  Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
  Plug 'parsonsmatt/intero-neovim', {'for': 'haskell'}
else
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'tpope/vim-sensible'
endif

" programming
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'

" editing
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
Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

" javascript
Plug 'tpope/vim-jdaddy', {'for': 'json'}

" misc
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'sjl/vitality.vim'
Plug 'diepm/vim-rest-console', {'for': 'rest'}
Plug 'lambdalisue/vim-rplugin'

" haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'alx741/vim-hindent', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'Twinside/vim-hoogle', {'for': 'haskell'}

" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}

" go lang
Plug 'fatih/vim-go', {'for': 'go'}

call plug#end()
