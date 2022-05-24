call plug#begin('~/.cache/plugged_vim')
Plug 'sjl/vitality.vim'
Plug 'tpope/vim-sensible'

" editing
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}
Plug 'ellisonleao/glow.nvim', {'on':  'Glow' }

" navigating
Plug 'junegunn/fzf.vim'
Plug '/opt/homebrew/opt/fzf'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-projectionist'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose', {'on': 'SmartClose'}

" vim interface
Plug 'arcticicestudio/nord-vim'
Plug 'zekzekus/menguless'

" programming
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'preservim/tagbar', 				 {'on': 'TagbarToggle'}
Plug 'AndrewRadev/linediff.vim', {'on':  'Linediff'}
Plug 'tpope/vim-dadbod',         {'on':  'DB'}

" languages
Plug 'tpope/vim-jdaddy',        {'for': 'json'}
Plug 'tpope/vim-salve',         {'for': 'clojure'}
Plug 'tpope/vim-fireplace',     {'for': 'clojure'}
Plug 'eraserhd/parinfer-rust',  {'do': 'cargo build --release', 'for': ['clojure', 'lisp']}
Plug 'clojure-vim/vim-jack-in', {'for': 'clojure' }

Plug 'tpope/vim-bundler',      {'for': 'ruby' }
Plug 'tpope/vim-rails',        {'for': 'ruby' }
Plug 'tpope/vim-rake',         {'for': 'ruby' }

call plug#end()
