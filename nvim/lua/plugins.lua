local execute = vim.api.nvim_command

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '.. install_path)
end

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

local use = require('packer').use
require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'tpope/vim-sleuth'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'jiangmiao/auto-pairs'
	use 'junegunn/goyo.vim'
	use 'Shougo/junkfile.vim'

	use 'junegunn/fzf.vim'
	use '/usr/local/opt/fzf'
	use 'tpope/vim-unimpaired'
	use 'farmergreg/vim-lastplace'
	use 'christoomey/vim-tmux-navigator'
	use 'szw/vim-smartclose'

	use 'arcticicestudio/nord-vim'

	use 'sheerun/vim-polyglot'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-commentary'
	use 'AndrewRadev/linediff.vim'
	use 'tpope/vim-dadbod'

	use 'tpope/vim-jdaddy'

	use 'nvim-treesitter/nvim-treesitter'
	use 'kyazdani42/nvim-web-devicons'
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'
	use 'neovim/nvim-lspconfig'
	use 'kyazdani42/nvim-tree.lua'
	use 'nvim-lua/completion-nvim'
	use 'steelsojka/completion-buffers'
	use 'kristijanhusak/completion-tags'
	use 'lewis6991/gitsigns.nvim'
end)
