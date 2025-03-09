local vim = vim

return {
  {
    'mcchrish/zenbones.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd[[colorscheme nordbones]]
    end
  },

  'LionC/nest.nvim',
  'christoomey/vim-tmux-navigator',
  'tpope/vim-sleuth',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'tpope/vim-fugitive',
  'Shougo/junkfile.vim',

  { 'tpope/vim-dadbod',               cmd = 'DB' },
  { 'preservim/tagbar',               cmd = 'TagbarToggle' },
  { 'szw/vim-smartclose',             cmd = 'SmartClose' },
  { 'AndrewRadev/linediff.vim',       cmd = 'Linediff' },
  { 'gpanders/nvim-parinfer',         ft  = 'clojure' },
  { 'clojure-vim/vim-jack-in',        ft  = 'clojure' },
  { 'tpope/vim-fireplace',            ft  = 'clojure' },
  { 'tpope/vim-jdaddy',               ft  = 'json' },
  { 'windwp/nvim-autopairs',          config = true, },
  { 'ethanholz/nvim-lastplace',       config = true, },
  { 'lewis6991/gitsigns.nvim',        config = true, },
  { 'ellisonleao/glow.nvim',          config = true, },
  { 'radenling/vim-dispatch-neovim',  dependencies = 'tpope/vim-dispatch', },
  { 'SmiteshP/nvim-navic',            dependencies = 'neovim/nvim-lspconfig', },

  { 'tpope/vim-rails',               ft = { 'ruby', 'eruby', 'haml', 'slim' } },
  { 'tpope/vim-rake',                ft = 'ruby' },
  { 'tpope/vim-bundler',             ft = 'ruby' },
  { 'tpope/vim-endwise',             ft = 'ruby' },

  {
    'rebelot/heirline.nvim',
    config = function() require('config.heirline') end,
    dependencies = { 'ojroques/nvim-hardline' },
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'fcying/telescope-ctags-outline.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {'debugloop/telescope-undo.nvim'},
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
      -- {'zbirenbaum/copilot-cmp'},
      -- {'zbirenbaum/copilot.lua'},

      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  },

  {
    'NeogitOrg/neogit',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',

      'nvim-telescope/telescope.nvim',
    },
    config = true
  },

  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    config = function() require('config.avante') end,
    opts = { },
    build = 'make',
    dependencies = {
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',

      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      'zbirenbaum/copilot-cmp',
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true, },
          use_absolute_path = true,
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
