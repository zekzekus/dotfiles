local packer = prequire("config.packer")

if not packer then
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'github/copilot.vim'

  use 'jiangmiao/auto-pairs'
  use 'farmergreg/vim-lastplace'
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
  use 'LionC/nest.nvim'

  use { 'mcchrish/zenbones.nvim',           requires = { 'rktjmp/lush.nvim' } }
  use { 'preservim/tagbar',                 cmd      = { 'TagbarToggle' } }
  use { 'ellisonleao/glow.nvim',            cmd      = { 'Glow' } }
  use { 'Shougo/junkfile.vim',              cmd      = { 'JunkfileOpen' } }
  use { 'szw/vim-smartclose',               cmd      = { 'SmartClose' } }
  use { 'AndrewRadev/linediff.vim',         cmd      = { 'Linediff' } }
  use { 'tpope/vim-dadbod',                 cmd      = { 'DB' } }
  use { 'gpanders/nvim-parinfer',           ft       = { 'clojure' } }
  use { 'clojure-vim/vim-jack-in',          ft       = { 'clojure' } }
  use { 'tpope/vim-fireplace',              ft       = { 'clojure' } }
  use { 'tpope/vim-bundler',                ft       = { 'ruby' } }
  use { 'tpope/vim-rails',                  ft       = { 'ruby' } }
  use { 'tpope/vim-rake',                   ft       = { 'ruby' } }
  use { 'tpope/vim-jdaddy',                 ft       = { 'json' } }

  use {
    'alvarosevilla95/luatab.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() default_config('luatab') end,
  }

  use {
    'ojroques/nvim-hardline',
    config = function() require('config.hardline') end,
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
    'neovim/nvim-lspconfig',
    config = function() require('config.lsp-config') end,
    requires = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'tami5/lspsaga.nvim' },
    },
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
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
    config = function() require('config.neotree') end,
  }

end)
