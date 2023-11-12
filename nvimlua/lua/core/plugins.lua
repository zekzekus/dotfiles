local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'christoomey/vim-tmux-navigator'
  use 'szw/vim-smartclose'
  use 'ellisonleao/gruvbox.nvim'
  use 'shaunsingh/nord.nvim'
  use 'LionC/nest.nvim'

  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  -- use 'nvim-tree/nvim-tree.lua'
  -- use 'nvim-tree/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }

  use {
    "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    }


  -- use {
  --   'VonHeikemen/lsp-zero.nvim',
  --   branch = 'v3.x',
  --   requires = {
  --     --- Uncomment these if you want to manage LSP servers from neovim
  --     -- {'williamboman/mason.nvim'},
  --     -- {'williamboman/mason-lspconfig.nvim'},

  --     -- LSP Support
  --     {'neovim/nvim-lspconfig'},
  --     -- Autocompletion
  --     {'hrsh7th/nvim-cmp'},
  --     {'hrsh7th/cmp-nvim-lsp'},
  --     {'L3MON4D3/LuaSnip'},
  --   }
  -- }

  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
