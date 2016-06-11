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

" navigating
Plug 'tpope/vim-vinegar'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-grepper'
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/junkfile.vim'
Plug 'tpope/vim-unimpaired'

" vim interface
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'szw/vim-smartclose'

" python
Plug 'davidhalter/jedi-vim'
Plug 'hynek/vim-python-pep8-indent'
Plug 'jmcantrell/vim-virtualenv'

" javascript
Plug 'tpope/vim-jdaddy'

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

" haskell
Plug 'dag/vim2hs'

" golang
Plug 'fatih/vim-go'

" rust-lang
Plug 'rust-lang/rust.vim'

call plug#end()
