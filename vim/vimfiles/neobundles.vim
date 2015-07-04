set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

" bundles bundles
NeoBundleFetch 'Shougo/neobundle.vim'

" programming
NeoBundle 'SirVer/ultisnips'
NeoBundle 'zekzekus/vim-snippets'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'gregsexton/gitv'

" editing
NeoBundle 'Raimondi/delimitMate.git'
NeoBundle 'sjl/gundo.vim.git'
NeoBundle 'tpope/vim-commentary.git'
NeoBundle 'tpope/vim-repeat.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'tpope/vim-unimpaired.git'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'godlygeek/tabular'

" navigating
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'AndrewRadev/linediff.vim.git'
NeoBundle 'Lokaltog/vim-easymotion.git'
NeoBundle 'majutsushi/tagbar.git'
NeoBundle 'rizzatti/greper.vim.git'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'osyo-manga/unite-airline_themes'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/junkfile.vim'

" vim interface
NeoBundle 'bling/vim-bufferline.git'
NeoBundle 'flazz/vim-colorschemes.git'
NeoBundle 'zekzekus/vim-airline.git'

" python
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'hynek/vim-python-pep8-indent.git'
NeoBundle 'jmcantrell/vim-virtualenv.git'

" javascript
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'pangloss/vim-javascript.git'
NeoBundle 'tpope/vim-jdaddy'

" django
NeoBundle 'mjbrownie/django-template-textobjects'

" misc
NeoBundle 'christoomey/vim-tmux-navigator.git'
NeoBundle 'Shougo/vimproc.vim.git', {
        \   'build': {
        \     'mac': 'make',
        \     'linux': 'make',
        \   }
        \ }
NeoBundle 'rizzatti/dash.vim.git'
NeoBundle 'rizzatti/funcoo.vim.git'
NeoBundle 'sjl/vitality.vim.git'
NeoBundle 'tpope/vim-markdown.git'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'diepm/vim-rest-console'

" haskell
NeoBundle 'dag/vim2hs'
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'eagletmt/neco-ghc'
NeoBundle 'Twinside/vim-hoogle'
NeoBundle 'ujihisa/unite-haskellimport'
NeoBundle 'nbouscal/vim-stylish-haskell'

call neobundle#end()

