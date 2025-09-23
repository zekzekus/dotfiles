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
    'NeogitOrg/neogit',
    branch = 'master',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',

      'nvim-telescope/telescope.nvim',
    },
    config = true
  },

}
