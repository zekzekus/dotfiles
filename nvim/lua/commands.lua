local vim = vim
local utils = require('utils')

vim.cmd.packadd('cfilter')
vim.o.undofile = true

vim.api.nvim_create_user_command('Zredir', utils.redir, {
  nargs = 1,
  complete = 'command',
  bar = true,
  range = true,
})

vim.api.nvim_create_user_command('Zgrep', utils.grep, {
  nargs = '+',
  complete = 'file_in_path',
  bar = true,
})

vim.api.nvim_create_user_command('Junky', function(opts)
  utils.open_junkfile(opts.args)
end, { nargs = '?' })

local augroup = vim.api.nvim_create_augroup('general_au', { clear = true })

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  pattern = '*',
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  pattern = '*',
  callback = function()
    require('heirline').reset_highlights()
  end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = augroup,
  pattern = { 'cgetexpr', 'cexpr' },
  command = 'cwindow',
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

vim.g.netrw_liststyle = 3
vim.g.zek_has_replied = false
vim.g.neo_tree_remove_legacy_commands = 1
