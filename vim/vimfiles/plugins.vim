call plug#begin('~/.vim/plugged')

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
Plug 'Valloric/YouCompleteMe', {'do': 'install.py --clang-completer --gocode-completer --racer-completer --tern-completer'}
Plug 'reedes/vim-pencil'
Plug 'godlygeek/tabular'

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/junkfile.vim'
Plug 'tpope/vim-unimpaired'

" vim interface
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-signify'

" python
Plug 'davidhalter/jedi-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'jmcantrell/vim-virtualenv'

" javascript
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-jdaddy'
Plug 'mxw/vim-jsx'

" django
Plug 'mjbrownie/django-template-textobjects'

" misc
Plug 'christoomey/vim-tmux-navigator'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'rizzatti/dash.vim'
Plug 'rizzatti/funcoo.vim'
Plug 'sjl/vitality.vim'
Plug 'kana/vim-textobj-user'
Plug 'diepm/vim-rest-console'
Plug 'benmills/vimux'
Plug 'mhinz/vim-startify'

" haskell
Plug 'dag/vim2hs'
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'

" golang
Plug 'fatih/vim-go'

" rust-lang
Plug 'rust-lang/rust.vim'

" html
Plug 'mattn/emmet-vim'

call plug#end()
