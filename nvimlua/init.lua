vim.g.neovim_data_dir = '$HOME/nvim-datadir'

require("utils")
require("core.keymaps")
require("core.plugins")
require("core.plugin_config")
require("options")
require("keybindings")

-- vim.cmd("source $HOME\\AppData\\Local\\nvim\\viml.vim")
-- vim.cmd("source $HOME/.config/nvim/viml.vim")
vim.cmd("source " .. vim.fn.stdpath("config") .. "/viml.vim")
