local prequire = require('utils').prequire

local tsitter = prequire('nvim-treesitter.configs')

if not tsitter then
  return
end

tsitter.setup {
  auto_install = false,
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
