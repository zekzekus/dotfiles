function! DoRemote(arg)
  if has('nvim')
    UpdateRemotePlugins
  endif
endfunction

if !has('nvim')
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'tpope/vim-sensible'
  Plug 'sjl/vitality.vim'
else
  call plug#begin('~/.config/nvim/plugged')
endif

" programming
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog', {'on': ['Flog', 'Flogsplit']}
Plug 'neoclide/coc.nvim', {'do': 'yarn install'}
Plug 'Shougo/neco-vim', {'for': 'vim'}
Plug 'neoclide/coc-neco', {'for': 'vim'}
Plug 'honza/vim-snippets'

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
Plug 'Shougo/denite.nvim', {'do': function('DoRemote')}

" vim interface
Plug 'zekzekus/vim-two-firewatch'
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
Plug 'zekzekus/vim-cljfmt', {'for': 'clojure'}

" misc
Plug 'diepm/vim-rest-console', {'for': 'rest'}

call plug#end()
