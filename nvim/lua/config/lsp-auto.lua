-- Auto-enable LSP clients based on filetype. Configs come from nvim/lsp/*.lua
-- and nvim-lspconfig. Servers are not installed globally: each project's flake
-- devShell (via direnv) puts them on PATH, and Neovim skips any whose command
-- is missing.

vim.lsp.enable({
  'lua_ls',
  'gopls',
  'rust_analyzer',
  'hls',
  'nil_ls',
  'nixd',
  'ty',
  'ruff',
  'clojure_lsp',
})
