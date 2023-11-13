local vim = vim

vim.g.mapleader = ' '
vim.gmaplocalleader = ' '

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- vim.keymap.set('n', '<BS>', ':nohlsearch<CR>')

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = false})
vim.g.mapleader = " "
vim.g.maplocalleader = " "
