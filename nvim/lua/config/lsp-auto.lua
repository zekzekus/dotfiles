-- Auto-enable LSP clients based on filetype
-- Neovim nightly auto-discovers configs in nvim/lsp/*.lua
-- vim.lsp.enable() activates them when you open matching filetypes

vim.lsp.enable({
  'lua_ls',
  'gopls',
  'rust_analyzer',
  'hls',
  'nil_ls',
  'nixd'
})
