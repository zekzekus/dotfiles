if !has('nvim')
  call plug#begin('~/.cache/plugged_vim')
  Plug 'sjl/vitality.vim'
  Plug 'tpope/vim-sensible'
else
  call plug#begin('~/.cache/plugged_nvim')
endif

" editing
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim',   {'on': 'Goyo'}
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}

" navigating
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug '/usr/local/opt/fzf'
Plug 'tpope/vim-unimpaired'
Plug 'farmergreg/vim-lastplace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'szw/vim-smartclose', {'on': 'SmartClose'}

" vim interface
Plug 'arcticicestudio/nord-vim'

" programming
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'preservim/tagbar', 				 {'on': 'TagbarToggle'}
Plug 'AndrewRadev/linediff.vim', {'on':  'Linediff'}
Plug 'tpope/vim-dadbod',         {'on':  'DB'}

Plug 'tpope/vim-jdaddy', {'for': 'json'}

call plug#end()
