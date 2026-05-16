local prequire = require('utils').prequire

local heirline = prequire('heirline')

if not heirline then
  return
end

local vim = vim

vim.g.neobones = {
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
  local colorscheme = vim.o.background == 'dark' and 'neobones' or 'vimbones'
  vim.cmd('colorscheme ' .. colorscheme)
  heirline.reset_highlights()
end

vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = set_colorscheme,
})

-- Make parens/brackets subtler in lisp-family files (Clojure, etc.).
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'clojure', 'lisp', 'scheme', 'fennel', 'racket' },
  callback = function()
    local subtle = vim.o.background == 'dark' and '#5c636b' or '#a89a88'
    vim.api.nvim_set_hl(0, '@punctuation.bracket', { fg = subtle })
    vim.api.nvim_set_hl(0, 'clojureParen', { fg = subtle })
    vim.api.nvim_set_hl(0, 'lispParen', { fg = subtle })
    vim.api.nvim_set_hl(0, 'schemeParen', { fg = subtle })
  end,
})

set_colorscheme()
