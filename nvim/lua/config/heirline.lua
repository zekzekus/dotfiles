local heirline = prequire('heirline')
local fmt = string.format

if not heirline then
  return
end

local Align = { provider = "%=" }
local Space = { provider = " " }
-- local Separator = { provider = "|" }

local set_hlgroups = function()
  local theme = require('hardline.themes.default')
  for class, attr in pairs(theme) do
    for state, args in pairs(attr) do
      local hlgroup = fmt('Hardline_%s_%s', class, state)
      local a = {}
      for k, v in pairs(args) do
        table.insert(a, fmt('%s=%s', k, v))
      end
      a = table.concat(a, ' ')
      vim.cmd(fmt('autocmd VimEnter,ColorScheme * hi %s %s', hlgroup, a))
    end
  end
end

set_hlgroups()

local merge_hl = function (hl, item_fn)
  return {
    provider = function()
      return fmt('%%#%s#%s%%*', hl, item_fn())
    end
  }
end

local Mode = merge_hl('Hardline_mode_normal', require('hardline.parts.mode').get_item)
local Git = merge_hl('Hardline_high_active', require('hardline.parts.git').get_item)
local Filename = merge_hl('Hardline_med_active', require('hardline.parts.filename').get_item)
local WordCount = merge_hl('Hardline_med_active', require('hardline.parts.wordcount').get_item)
local LspError = merge_hl('Hardline_warning_active', require('hardline.parts.lsp').get_error)
local LspWarning = merge_hl('Hardline_warning_active', require('hardline.parts.lsp').get_warning)
local Whitespace = merge_hl('Hardline_warning_active', require('hardline.parts.whitespace').get_item)
local Filetype = merge_hl('Hardline_high_active', require('hardline.parts.filetype').get_item)
local Lines = merge_hl('Hardline_warning_active', require('hardline.parts.line').get_item)
local ListInfos = merge_hl('Hardline_mode_normal', listinfos)

heirline.setup({
  statusline = {
    Mode,
    Space,
    Git,
    Space,
    Filename,
    Align,
    WordCount,
    Space,
    LspError,
    Space,
    LspWarning,
    Space,
    Whitespace,
    Space,
    Filetype,
    Space,
    Lines,
    Space,
    ListInfos,
  }
})
