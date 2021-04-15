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
" Plug 'sheerun/vim-polyglot'  # read something about it breaks thing together with treesitter
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'AndrewRadev/linediff.vim',       {'on':  'Linediff'}
Plug 'tpope/vim-dadbod',               {'on':  'DB'}

Plug 'tpope/vim-jdaddy', {'for': 'json'}

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'TimUntersberger/neogit'
Plug 'nvim-lua/completion-nvim'
Plug 'steelsojka/completion-buffers'
Plug 'kristijanhusak/completion-tags'
Plug 'lewis6991/gitsigns.nvim'
Plug 'famiu/feline.nvim'

call plug#end()
