local vim = vim

return {
  {
    'mcchrish/zenbones.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.neobones = {
        solid_line_nr = true,
        solid_float_border = true,
        italic_strings = false,
      }

      local function set_colorscheme()
        local colorscheme = vim.o.background == 'dark' and 'kanagawabones' or 'vimbones'
        vim.cmd('colorscheme ' .. colorscheme)
        require('heirline').reset_highlights()
      end

      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'background',
        callback = set_colorscheme,
      })

      set_colorscheme()
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

  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono'
      },

      completion = { documentation = { auto_show = false } },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },

  {
    'dmtrKovalenko/fff.nvim',
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      debug = {
        enabled = true,
        show_scores = true,
      },
    },
    lazy = false,
    keys = {
      {
        "ff",
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      }
    }
  },

}
