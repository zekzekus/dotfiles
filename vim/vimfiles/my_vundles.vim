set runtimepath+=~/.vim/bundle/vundle
call vundle#begin()

" bundles bundles
Plugin 'gmarik/vundle'

" programming
Plugin 'vim-scripts/paredit.vim'
Plugin 'SirVer/ultisnips'
Plugin 'zekzekus/vim-snippets'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mhinz/vim-signify.git'
Plugin 'scrooloose/syntastic.git'
Plugin 'tpope/vim-fugitive.git'

" editing
Plugin 'Raimondi/delimitMate.git'
Plugin 'sjl/gundo.vim.git'
Plugin 'tpope/vim-commentary.git'
Plugin 'tpope/vim-repeat.git'
Plugin 'tpope/vim-surround.git'
Plugin 'tpope/vim-unimpaired.git'

" navigating
Plugin 'AndrewRadev/linediff.vim.git'
Plugin 'Lokaltog/vim-easymotion.git'
Plugin 'kien/ctrlp.vim.git'
Plugin 'majutsushi/tagbar.git'
Plugin 'rizzatti/greper.vim.git'
Plugin 'scrooloose/nerdtree.git'

" vim interface
Plugin 'bling/vim-bufferline.git'
Plugin 'flazz/vim-colorschemes.git'
Plugin 'miyakogi/conoline.vim'
Plugin 'zekzekus/vim-airline.git'

" python
Plugin 'hynek/vim-python-pep8-indent.git'
Plugin 'jmcantrell/vim-virtualenv.git'

" javascript
Plugin 'pangloss/vim-javascript.git'
Plugin 'marijnh/tern_for_vim'

" html
Plugin 'mattn/emmet-vim.git'

" django
Plugin 'mjbrownie/django-template-textobjects'

" clojure
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-fireplace'

" misc
Plugin 'christoomey/vim-tmux-navigator.git'
Plugin 'Shougo/vimproc.vim.git'
Plugin 'rizzatti/dash.vim.git'
Plugin 'rizzatti/funcoo.vim.git'
Plugin 'sjl/vitality.vim.git'
Plugin 'tpope/vim-markdown.git'
Plugin 'kana/vim-textobj-user'

call vundle#end() 

