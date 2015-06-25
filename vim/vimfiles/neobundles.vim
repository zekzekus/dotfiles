set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))

" bundles bundles
NeoBundleFetch 'Shougo/neobundle.vim'

" programming
NeoBundle 'vim-scripts/paredit.vim'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'zekzekus/vim-snippets'
NeoBundle 'mhinz/vim-signify.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'gregsexton/gitv'

" editing
NeoBundle 'Plugin reedes/vim-pencil'
NeoBundle 'Raimondi/delimitMate.git'
NeoBundle 'sjl/gundo.vim.git'
NeoBundle 'tpope/vim-commentary.git'
NeoBundle 'tpope/vim-repeat.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'tpope/vim-unimpaired.git'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'reedes/vim-colors-pencil'
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
NeoBundle 'NLKNguyen/papercolor-theme'

" haskell
NeoBundle 'eagletmt/neco-ghc'
NeoBundle 'bitc/vim-hdevtools'
NeoBundle 'dag/vim2hs'

" python
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'hynek/vim-python-pep8-indent.git'
NeoBundle 'jmcantrell/vim-virtualenv.git'

" javascript
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'pangloss/vim-javascript.git'
NeoBundle 'marijnh/tern_for_vim', {
        \   'build': {
        \     'mac': 'npm install',
        \     'linux': 'npm install',
        \   }
        \ }
NeoBundle 'tpope/vim-jdaddy'

" html
NeoBundle 'mattn/emmet-vim.git'

" django
NeoBundle 'mjbrownie/django-template-textobjects'

" clojure
NeoBundle 'tpope/vim-fireplace'

" go
NeoBundle 'fatih/vim-go'

" elixir
NeoBundle 'elixir-lang/vim-elixir'

" erlang
NeoBundle 'jimenezrick/vimerl'

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

call neobundle#end()

