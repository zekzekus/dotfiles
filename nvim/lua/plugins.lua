local packer = prequire("config.packer")

if not packer then
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-sleuth'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'jiangmiao/auto-pairs'
  use 'junegunn/fzf.vim'
  use '/usr/local/opt/fzf'
  use 'tpope/vim-unimpaired'
  use 'farmergreg/vim-lastplace'
  use 'christoomey/vim-tmux-navigator'
  use 'sheerun/vim-polyglot'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-commentary'
  use 'LionC/nest.nvim'
  use 'tpope/vim-dispatch'
  use 'radenling/vim-dispatch-neovim'

  use { 'preservim/tagbar',                 cmd      = { 'TagbarToggle' } }
  use { 'ellisonleao/glow.nvim',            cmd      = { 'Glow' } }
  use { 'Shougo/junkfile.vim',              cmd      = { 'JunkfileOpen' } }
  use { 'szw/vim-smartclose',               cmd      = { 'SmartClose' } }
  use { 'AndrewRadev/linediff.vim',         cmd      = { 'Linediff' } }
  use { 'tpope/vim-dadbod',                 cmd      = { 'DB' } }
  use { 'nvim-treesitter/nvim-treesitter',  run      = { ':TSUpdate' } }
  use { 'gpanders/nvim-parinfer',           ft       = { 'clojure' } }
  use { 'clojure-vim/vim-jack-in',          ft       = { 'clojure' } }
  use { 'tpope/vim-jdaddy',                 ft       = { 'json' } }
  use { 'tpope/vim-fireplace',              ft       = { 'clojure' } }
  use { 'mcchrish/zenbones.nvim',           requires = { 'rktjmp/lush.nvim' } }
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
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function() default_config('neogit') end,
    cmd = { 'Neogit' },
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    },
    config = function() require('config.telescope') end,
    cmd = { 'Telescope' },
  }

  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() default_config('nvim-tree') end,
      cmd = { 'NvimTreeToggle' },
  }

  use {
    'neovim/nvim-lspconfig',
    config = function() require('config.lspconfig') end,
    after = { 'cmp-nvim-lsp', 'nvim-lsp-installer' },
    requires = { { 'williamboman/nvim-lsp-installer' } },
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
    config = function() require('config.nvim-metals') end,
  }

end)
