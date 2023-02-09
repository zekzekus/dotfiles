local heirline = prequire('heirline')
local conditions = prequire('heirline.conditions')
local common = prequire('hardline.common')
local main_theme = prequire('hardline.themes.default')

local vim = vim

if not heirline then
  return
end

local Align = { provider = "%=" }
local Space = { provider = " " }

local create_part = function(item_fn, class)
  return {
    provider = item_fn,
    init = function(self)
      self.mode = common.modes[vim.fn.mode()] or common.modes['?']
    end,
    hl = function(self)
      local state = 'active'
      if class == 'mode' then
        state = self.mode.state
      end
      if conditions.is_active() then
        return {
          fg = main_theme[class][state]['guifg'],
          bg = main_theme[class][state]['guibg'],
        }
      else
        return {
          fg = main_theme[class]['inactive']['guifg'],
          bg = main_theme[class]['inactive']['guibg'],
        }
      end
    end
  }
end
local Mode = create_part(require('hardline.parts.mode').get_item, 'mode')
local Git = create_part(require('hardline.parts.git').get_item, 'high')
local Filename = create_part(require('hardline.parts.filename').get_item, 'med')
local WordCount = create_part(require('hardline.parts.wordcount').get_item, 'med')
local LspError = create_part(require('hardline.parts.lsp').get_error, 'warning')
local LspWarning = create_part(require('hardline.parts.lsp').get_warning, 'warning')
local Whitespace = create_part(require('hardline.parts.whitespace').get_item, 'warning')
local Filetype = create_part(require('hardline.parts.filetype').get_item, 'high')
local Lines = create_part(require('hardline.parts.line').get_item, 'warning')
local ListInfos = create_part(listinfos, 'warning')

local Statusline = {
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

heirline.setup({
  statusline = {Statusline}
})
