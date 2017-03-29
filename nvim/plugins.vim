if has('nvim')
  call plug#begin('~/.config/nvim/plugged')
  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction

  Plug 'zchee/deoplete-jedi', {'for': 'python'}
  Plug 'zchee/deoplete-go', {'for': 'go'}
  Plug 'Shougo/neco-vim', {'for': 'vim'}
  Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
else
  call plug#begin('~/.config/nvim/plugged_vim')
  Plug 'tpope/vim-sensible'
endif

" programming
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'benmills/vimux'
Plug 'AndrewRadev/linediff.vim'

" editing
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'szw/vim-smartclose'
Plug 'godlygeek/tabular'
Plug 'Ron89/thesaurus_query.vim'
Plug 'sjl/gundo.vim'

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'Shougo/unite.vim'
Plug 'Shougo/junkfile.vim'
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'yuttie/comfortable-motion.vim'

" vim interface
Plug 'lifepillar/vim-solarized8'
Plug 'zekzekus/vim-colors-off'
Plug 'robertmeta/nofrils'
Plug 'sjl/badwolf'

" python
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

" javascript
Plug 'tpope/vim-jdaddy'

" misc
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'sjl/vitality.vim'
Plug 'diepm/vim-rest-console', {'for': 'rest'}
Plug 'mhinz/vim-startify'

" haskell
Plug 'dag/vim2hs', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'Twinside/vim-hoogle', {'for': 'haskell'}

" rust-lang
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'racer-rust/vim-racer', {'for': 'rust'}

" go lang
Plug 'fatih/vim-go', {'for': 'go'}

call plug#end()
