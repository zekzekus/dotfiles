local prequire = require('utils').prequire

local vim = vim
local lsp_zero = prequire('lsp-zero')
local mason = prequire('mason')
local mason_lspconfig = prequire('mason-lspconfig')
local navic = prequire('nvim-navic')
local lspsaga = prequire('lspsaga')
local cmp = prequire('cmp')
local cmp_autopairs = prequire('nvim-autopairs.completion.cmp')
local cmp_action = lsp_zero.cmp_action()
local lspconfig = prequire('lspconfig')
local copilot = prequire('copilot')
local copilot_cmp = prequire('copilot_cmp')

local function custom_root_pattern(opt)
  local root = opt.root
  local not_root_pattern = opt.not_root

  local function matches(path, pattern)
    return 0 < #vim.fn.glob(lspconfig.util.path.join(path, pattern))
  end

  return function(startpath)
    local not_root = lspconfig.util.search_ancestors(startpath, function(path)
      return matches(path, not_root_pattern)
    end)
    if not_root ~= nil then
      -- if this is a valid root dir for the given not_root pattern thendo
      -- do not try given root and do not attach this server at all
      return false
    end
    return lspconfig.util.search_ancestors(startpath, function(path)
      return matches(path, root)
    end)
  end
end

lsp_zero.on_attach(function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- set mappings only in current buffer with lsp enabled
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<space>a', '<cmd>Lspsaga code_action<cr>', opts)
  buf_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
  buf_set_keymap('n', 'gp', '<cmd>Lspsaga peek_definition<cr>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>Lspsaga signature_help<cr>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>Lspsaga rename<cr>', opts)
  buf_set_keymap('n', 'gr', '<cmd>Lspsaga finder def+ref+imp<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
  buf_set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
  buf_set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
end)

mason.setup({})
mason_lspconfig.setup({
  ensure_installed = {},
  handlers = {
    lsp_zero.default_setup,
    tsserver = function()
      lspconfig.tsserver.setup({
        root_dir = custom_root_pattern({root='package.json', not_root='deno.json?'}),
        single_file_support = false
      })
    end,
    denols = function()
      lspconfig.denols.setup({
        root_dir = lspconfig.util.root_pattern('deno.json')
      })
    end,
    hls = function()
      lspconfig.hls.setup({
        cmd = {'ghcup', 'run', 'haskell-language-server-wrapper', '--', '--lsp'},
      })
    end,
    rust_analyzer = function()
      lspconfig.rust_analyzer.setup({
        cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
      })
    end,
  }
})

copilot.setup({
  suggestion = {enabled = false},
  panel = {enabled = false},
})
copilot_cmp.setup()

cmp.setup({
  sources = {
    {name = 'copilot'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip'},
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),

    ['<CR>'] = cmp.mapping.confirm({
      select = false,
      behavior = cmp.ConfirmBehavior.Replace,
    }),

    ['<C-Space>'] = cmp.mapping.complete(),

    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

lspsaga.setup({
  symbol_in_winbar = {
    enable = false,
  },
  lightbulb = {
    enable = false,
  },
  finder = {
    keys = {
      vsplit = 'v',
      split = 's',
      toggle_or_open = '<cr>',
    }
  }
})
