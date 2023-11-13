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

  -- Navigation like tmux
  use 'christoomey/vim-tmux-navigator'

  -- Self explanatory (<leader>Q)
  use 'szw/vim-smartclose'

  if os.getenv("OPENAI_API_KEY") ~= nil then
    -- AI
    use({
      "jackMort/ChatGPT.nvim",
        config = function()
          require("chatgpt").setup()
        end,
        requires = {
          "MunifTanjim/nui.nvim",
          "nvim-lua/plenary.nvim",
          "nvim-telescope/telescope.nvim"
        }
    })
  end

  -- Colorschemes
  use 'ellisonleao/gruvbox.nvim'
  use 'shaunsingh/nord.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }

  -- venv Selector
  use 'AckslD/swenv.nvim'

  -- Nest keybindings
  use 'LionC/nest.nvim'

  -- Commenting
  use 'tpope/vim-commentary'

  -- Auto brackets, parentheses and quotes
  use 'jiangmiao/auto-pairs'
  -- Quickly change brackets, parens, quotes
  use 'tpope/vim-surround'

  -- Open VIM at last cursor position
  use 'farmergreg/vim-lastplace'

  -- snippets
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'quangnguyen30192/cmp-nvim-ultisnips'

  -- completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  -- use 'L3MON4D3/LuaSnip'

  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'
  use {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" }
  }

  -- Navigation
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'fcying/telescope-ctags-outline.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim'},
    }
  }
  use 'fcying/telescope-ctags-outline.nvim'
  use 'nvim-lua/popup.nvim'
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

  -- use 'nvim-tree/nvim-tree.lua'
  -- use 'nvim-tree/nvim-web-devicons'

  use 'nvim-lualine/lualine.nvim'

  use { "yioneko/nvim-yati", tag = "*", requires = "nvim-treesitter/nvim-treesitter" }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",
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
