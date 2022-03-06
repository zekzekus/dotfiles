local packer = prequire("config.packer")

if not packer then
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

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
  use { 'tpope/vim-rails',                  ft       = { 'ruby' }, }
  use { 'tpope/vim-rake',                   ft       = { 'ruby' }, }
  use { 'tpope/vim-jdaddy',                 ft       = { 'json' } }

  use {
    'alvarosevilla95/luatab.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() default_config('luatab') end,
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
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    },
    config = function() require('config.telescope') end,
    cmd = { 'Telescope' },
  }

  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require('config.nvim-tree') end,
      cmd = { 'NvimTreeToggle' },
  }

  use {
    'neovim/nvim-lspconfig',
    config = function() require('config.lspconfig') end,
    after = { 'cmp-nvim-lsp', 'nvim-lsp-installer' },
    requires = {
      { 'williamboman/nvim-lsp-installer' },
      { 'tami5/lspsaga.nvim' },
    },
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp', },
    },
    config = function() require('config.cmp') end,
  }

  use {
    'scalameta/nvim-metals',
    requires = { "nvim-lua/plenary.nvim" },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() default_config('nvim-treesitter') end,
    run = { ':TSUpdate' }
  }

end)
