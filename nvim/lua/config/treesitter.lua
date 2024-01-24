local tsitter = prequire('nvim-treesitter.configs')

if not tsitter then
  return
end

tsitter.setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      node_decremental = 'grm',
      scope_incremental = 'grc',
    }
  },
}
