local prequire = require('utils').prequire

local heirline = prequire('heirline')

if not heirline then
  return
end

local vim = vim

vim.g.kanagawabones = {
  solid_line_nr = true,
  solid_float_border = true,
  italic_strings = false,
}
vim.g.vimbones = {
  solid_line_nr = true,
  solid_float_border = true,
  italic_strings = false,
}

local function set_colorscheme()
  local colorscheme = vim.o.background == 'dark' and 'kanagawabones' or 'vimbones'
  vim.cmd('colorscheme ' .. colorscheme)
  heirline.reset_highlights()
end

vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = set_colorscheme,
})

set_colorscheme()
