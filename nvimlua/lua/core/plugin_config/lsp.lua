require("mason").setup()
require("mason-lspconfig").setup({
	-- ensure_installed = { "lua_ls", "pylsp", "pyright" }
  ensure_installed = { "lua_ls", "pylsp" }
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()


require("lspconfig").lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("lspconfig").pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
}

-- require("lspconfig").pyright.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = {"python"},
-- }
