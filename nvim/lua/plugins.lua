local vim = vim

return {
  {
    'mcchrish/zenbones.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme neobones]]
    end
  },

  'LionC/nest.nvim',
  'christoomey/vim-tmux-navigator',
  'tpope/vim-sleuth',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-fugitive',
  'tpope/vim-commentary',

  {
    'lervag/wiki.vim'
  },

  { 'tpope/vim-dadbod',         cmd = { 'DB' } },
  { 'preservim/tagbar',         cmd = { 'TagbarToggle' } },
  { 'Shougo/junkfile.vim',      cmd = { 'JunkfileOpen' } },
  { 'szw/vim-smartclose',       cmd = { 'SmartClose' } },
  { 'AndrewRadev/linediff.vim', cmd = { 'Linediff' } },
  { 'gpanders/nvim-parinfer',   ft  = { 'clojure' } },
  { 'clojure-vim/vim-jack-in',  ft  = { 'clojure' } },
  { 'tpope/vim-fireplace',      ft  = { 'clojure' } },
  { 'tpope/vim-rails',          ft  = { 'ruby' } },
  { 'tpope/vim-rake',           ft  = { 'ruby' } },
  { 'tpope/vim-bundler',        ft  = { 'ruby' } },
  { 'tpope/vim-endwise',        ft  = { 'ruby' } },
  { 'tpope/vim-jdaddy',         ft  = { 'json' } },

  {
    'radenling/vim-dispatch-neovim',
    dependencies = { 'tpope/vim-dispatch' },
  },

  {
    'windwp/nvim-autopairs',
    config = function() default_config('nvim-autopairs') end,
  },

  {
    'ethanholz/nvim-lastplace',
    config = function() default_config('nvim-lastplace') end,
  },

  {
    'ellisonleao/glow.nvim',
    cmd = { 'Glow' },
    config = function() default_config('glow') end,
  },

  {
    'rebelot/heirline.nvim',
    config = function() require('config.heirline') end,
    dependencies = { 'ojroques/nvim-hardline' },
  },

  {
    'lewis6991/gitsigns.nvim',
    config = function() default_config('gitsigns') end,
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'fcying/telescope-ctags-outline.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function() require('config.telescope') end,
    cmd = { 'Telescope' },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('config.treesitter') end,
    build = { ':TSUpdate' },
  },

  {
    'SmiteshP/nvim-navic',
    dependencies = 'neovim/nvim-lspconfig',
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function() require('config.neotree') end,
    cmd = { 'Neotree' },
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    event = { 'VeryLazy' },
    branch = 'v3.x',
    config = function() require('config.lsp-zero-3') end,
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      { 'nvimdev/lspsaga.nvim' },

      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},
      {'zbirenbaum/copilot-cmp'},
      {'zbirenbaum/copilot.lua'},

      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  },
}
