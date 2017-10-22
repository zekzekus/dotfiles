function! DoRemote(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

if has('nvim')
  call plug#begin('~/.config/nvim/plugged')

  Plug 'Shougo/denite.nvim', {'do': function('DoRemote')}
  Plug 'parsonsmatt/intero-neovim', {'for': 'haskell'}
else
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
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
Plug 'szw/vim-smartclose'
Plug 'farmergreg/vim-lastplace'
Plug 'Shougo/junkfile.vim'
Plug 'ervandew/supertab'

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tweekmonster/braceless.vim'

" vim interface
Plug 'morhetz/gruvbox'

" python
Plug 'davidhalter/jedi-vim', {'for': 'python'}

" javascript / JSON
Plug 'tpope/vim-jdaddy', {'for': 'json'}

" misc
Plug 'diepm/vim-rest-console', {'for': 'rest'}
Plug 'Shougo/vimproc.vim', {'do': 'make'}

" haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}

" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}

" go lang
Plug 'fatih/vim-go', {'for': 'go'}

" clojure
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
Plug 'guns/vim-sexp', {'for': 'clojure'}
Plug 'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}

call plug#end()
