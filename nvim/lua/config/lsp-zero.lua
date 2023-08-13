local lsp           = prequire("lsp-zero")
local lspconfig     = prequire("lspconfig")
local navic         = prequire("nvim-navic")
local lspsaga       = prequire("lspsaga")
local cmp           = prequire('cmp')
local cmp_autopairs = prequire('nvim-autopairs.completion.cmp')


local vim = vim

if not lsp then
  return
end

if not lspconfig then
  return
end

if not navic then
  return
end

if not lspsaga then
  return
end

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

lsp.preset("recommended")

lsp.configure("tsserver", {
  root_dir = custom_root_pattern({root="package.json", not_root="deno.json?"}),
  single_file_support = false
})
lsp.configure("denols", {
  root_dir = lspconfig.util.root_pattern("deno.json?")
})
lsp.set_preferences({
  set_lsp_keymaps = false,
  configure_diagnostics = false,
})
lsp.on_attach(function(client, bufnr)
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
  buf_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<cr>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>Lspsaga signature_help<cr>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>Lspsaga rename<cr>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<cr>', opts)
  buf_set_keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts)
  buf_set_keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
end)

lsp.setup()

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = false}),
  }
})

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

lspsaga.setup({
  symbol_in_winbar = {
    enable = false,
  }
})
