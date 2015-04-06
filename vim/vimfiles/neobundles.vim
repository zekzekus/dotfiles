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

" editing
NeoBundle 'Raimondi/delimitMate.git'
NeoBundle 'sjl/gundo.vim.git'
NeoBundle 'tpope/vim-commentary.git'
NeoBundle 'tpope/vim-repeat.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'tpope/vim-unimpaired.git'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'Shougo/neocomplete.vim'

" navigating
NeoBundle 'AndrewRadev/linediff.vim.git'
NeoBundle 'Lokaltog/vim-easymotion.git'
NeoBundle 'majutsushi/tagbar.git'
NeoBundle 'rizzatti/greper.vim.git'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'osyo-manga/unite-airline_themes'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/junkfile.vim'

" vim interface
NeoBundle 'bling/vim-bufferline.git'
NeoBundle 'flazz/vim-colorschemes.git'
NeoBundle 'zekzekus/vim-airline.git'

" python
NeoBundle 'hynek/vim-python-pep8-indent.git'
NeoBundle 'jmcantrell/vim-virtualenv.git'

" javascript
NeoBundle 'pangloss/vim-javascript.git'
NeoBundle 'marijnh/tern_for_vim'

" html
NeoBundle 'mattn/emmet-vim.git'

" django
NeoBundle 'mjbrownie/django-template-textobjects'

" clojure
NeoBundle 'tpope/vim-fireplace'

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

call neobundle#end()

