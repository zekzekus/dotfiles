local vim = vim

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = false})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins', },
  },
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  change_detection = {
    notify = false,
  },
})
