-- try to import lspconfig
local lspconfig = prequire("lspconfig")
local cmplsp = prequire("cmp_nvim_lsp")
local mason = prequire("mason")
local mason_lspconfig = prequire("mason-lspconfig")

if not lspconfig then
    return
end
if not cmplsp then
  return
end
if not mason then
  return
end

if not mason_lspconfig then
  return
end

local vim = vim

-- do something on lsp attach
local function on_attach(_, bufnr)
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
end

mason.setup()
mason_lspconfig.setup()

lspconfig["tsserver"].setup {
  autostart = true,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  capabilities = cmplsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
}

lspconfig["denols"].setup {
  autostart = true,
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json"),
  capabilities = cmplsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
}

local servers = { "gopls", "jdtls", "jsonls", "sumneko_lua", "pyright",
                  "rust_analyzer", "hls", "html", "clojure_lsp", "vimls",
                  "marksman", "rnix"}
for _, server in pairs(servers) do
  lspconfig[server].setup {
    autostart = true,
    on_attach = on_attach,
    capabilities = cmplsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end

vim.cmd [[ do User LspAttachBuffers ]]
