local packer = prequire("config.packer")

if not packer then
    return
end

packer.startup(function(use)
	use 'wbthomason/packer.nvim'

	use 'tpope/vim-sleuth'
	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'

	use {
		'lewis6991/gitsigns.nvim',
		config = function() require('config.gitsigns') end,
	}
	use {
		'TimUntersberger/neogit',
		requires = 'nvim-lua/plenary.nvim',
		config = function() require('config.neogit') end,
  }

	use 'jiangmiao/auto-pairs'
	use {
		'Shougo/junkfile.vim',
		opt = true,
		cmd = { 'JunkfileOpen' }
	}

	use 'junegunn/fzf.vim'
	use '/usr/local/opt/fzf'
	use 'tpope/vim-unimpaired'
	use 'farmergreg/vim-lastplace'
	use 'christoomey/vim-tmux-navigator'

	use {
		'szw/vim-smartclose',
		opt = true,
		cmd = { 'SmartClose' }
	}

	use 'arcticicestudio/nord-vim'
	use 'fenetikm/falcon'

	use 'sheerun/vim-polyglot'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-commentary'

	use {
		'AndrewRadev/linediff.vim',
		opt = true,
		cmd = { 'Linediff' }
	}

	use {
		'tpope/vim-dadbod',
		opt = true,
		cmd = { 'DB' }
	}

	use {
		'tpope/vim-jdaddy',
		opt = true,
		ft = { 'json' }
	}

	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

	use {
			'kyazdani42/nvim-tree.lua',
			requires = 'kyazdani42/nvim-web-devicons',
			config = function() require('config.nvimtree') end,
	}

	use 'preservim/tagbar'
	use 'LionC/nest.nvim'

	use {
		'neovim/nvim-lspconfig',
		config = function() require('config.lspconfig') end,
		after = 'cmp-nvim-lsp',
	}

	use {
		'hrsh7th/nvim-cmp',
		requires = {
				{ 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', },
		},
		config = function() require('config.cmp') end,
	}

	use 'tpope/vim-dispatch'
	use 'radenling/vim-dispatch-neovim'

	use {
		'clojure-vim/vim-jack-in',
		opt = true,
		ft = { 'clojure' },
	}
	use {
		'Olical/conjure',
		opt = true,
		ft = { 'clojure' },
	}

	use {
		'eraserhd/parinfer-rust',
		opt = true,
		run = 'cargo build --release',
		ft = { 'clojure' },
	}

end)
