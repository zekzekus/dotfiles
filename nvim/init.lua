require("utils")
require("plugins")
require("options")

vim.g.completion_chain_complete_list = {
  default = {
    { complete_items = { 'lsp' } },
    { complete_items = { 'buffers' } },
    { complete_items = { 'tags' } },
    { complete_items = { 'path' } },
    { mode = { '<c-p>' } },
    { mode = { '<c-n>' } }
  },
}

require("keybindings")
vim.cmd("source ~/.config/nvim/viml.vim")
