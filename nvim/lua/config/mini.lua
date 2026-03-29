local prequire = require('utils').prequire

local pairs = prequire('mini.pairs')
local surround = prequire('mini.surround')

if not pairs or not surround then
  return
end

local vim = vim

pairs.setup()
surround.setup({
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    suffix_last = '',
    suffix_next = '',
  },
  search_method = 'cover_or_next',
})

vim.keymap.del('x', 'ys')
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
vim.keymap.set('n', 'yss', 'ys_', { remap = true })
