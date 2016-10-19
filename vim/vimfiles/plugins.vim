call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

" programming
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" editing
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'szw/vim-smartclose'

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/junkfile.vim'
Plug 'tpope/vim-unimpaired'
Plug 'christoomey/vim-tmux-navigator'

" vim interface
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'lifepillar/vim-solarized8'

" python
Plug 'davidhalter/jedi-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'jmcantrell/vim-virtualenv'

" javascript
Plug 'tpope/vim-jdaddy'

" misc
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'sjl/vitality.vim'
Plug 'diepm/vim-rest-console'
Plug 'benmills/vimux'
Plug 'freitass/todo.txt-vim'

" haskell
Plug 'dag/vim2hs'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'

" golang
Plug 'fatih/vim-go'

" rust-lang
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

call plug#end()
