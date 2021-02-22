call plug#begin('~/.cache/plugged_nvim')

" editing
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim',   {'on': 'Goyo'}
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}

" navigating
Plug 'junegunn/fzf.vim'
Plug '/usr/local/opt/fzf'
Plug 'tpope/vim-unimpaired'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose', {'on': 'SmartClose'}

" vim interface
Plug 'arcticicestudio/nord-vim'

" programming
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dadbod',               {'on':  'DB'}
Plug 'AndrewRadev/linediff.vim',       {'on':  'Linediff'}

Plug 'tpope/vim-jdaddy', {'for': 'json'}

call plug#end()
