local packer = prequire("config.packer")

if not packer then
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'LionC/nest.nvim'

  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-dispatch'
  use 'radenling/vim-dispatch-neovim'

  use { 'mcchrish/zenbones.nvim',   requires = { 'rktjmp/lush.nvim' } }
  use { 'preservim/tagbar',         cmd      = { 'TagbarToggle' } }
  use { 'Shougo/junkfile.vim',      cmd      = { 'JunkfileOpen' } }
  use { 'szw/vim-smartclose',       cmd      = { 'SmartClose' } }
  use { 'AndrewRadev/linediff.vim', cmd      = { 'Linediff' } }
  use { 'tpope/vim-dadbod',         cmd      = { 'DB' } }
  use { 'gpanders/nvim-parinfer',   ft       = { 'clojure' } }
  use { 'clojure-vim/vim-jack-in',  ft       = { 'clojure' } }
  use { 'tpope/vim-fireplace',      ft       = { 'clojure' } }
  use { 'tpope/vim-jdaddy',         ft       = { 'json' } }

  use {
    'ethanholz/nvim-lastplace',
    config = function() default_config('nvim-lastplace') end,
  }

  use {
    'ellisonleao/glow.nvim',
    cmd = { 'Glow' },
    config = function() default_config('glow') end,
  }

  use {
    "rebelot/heirline.nvim",
    config = function() require('config.heirline') end,
    requires = { 'ojroques/nvim-hardline' },
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function() default_config('gitsigns') end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'fcying/telescope-ctags-outline.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function() require('config.telescope') end,
    cmd = { 'Telescope' },
  }

  use {
    'scalameta/nvim-metals',
    requires = { "nvim-lua/plenary.nvim" },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('config.treesitter') end,
    run = { ':TSUpdate' },
  }

  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
  }

  use {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
    config = function() require('config.neotree') end,
  }

  use {
    'VonHeikemen/lsp-zero.nvim',
    config = function() require('config.lsp-zero') end,
    requires = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      { 'nvimdev/lspsaga.nvim' },

      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  }

  use {
    'windwp/nvim-autopairs',
    config = function() default_config('nvim-autopairs') end,
  }

end)
