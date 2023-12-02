local vim = vim

vim.g.mapleader = ' '
vim.gmaplocalleader = ' '

-- vim.keymap.set('n', '<BS>', ':nohlsearch<CR>')

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = false})
vim.g.mapleader = " "
vim.g.maplocalleader = " "
