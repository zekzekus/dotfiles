local heirline    = prequire('heirline')
local utils       = prequire('heirline.utils')
local conditions  = prequire('heirline.conditions')

local p = prequire('config.heirline.parts')

local vim = vim

if not heirline then
  return
end

local Align       = { provider = "%=" }

local FileInfo    = p.create_part(p.get_filename, 'warning')
local Readonly    = p.create_part(p.get_readonly, 'warning')
local Modified    = p.create_part(p.get_modified, 'warning')
local Filename    = { FileInfo, Readonly, Modified }

local Mode        = p.create_part(require('hardline.parts.mode').get_item, 'mode')
local Git         = p.create_part(require('hardline.parts.git').get_item, 'high')

local Dirname     = p.create_part(p.get_dirname, 'med')
local LspError    = p.create_part(p.get_lsp_errors, 'warning')
local LspWarning  = p.create_part(p.get_lsp_warnings, 'warning')
local Whitespace  = p.create_part(require('hardline.parts.whitespace').get_item, 'warning')
local Filetype    = p.create_part(require('hardline.parts.filetype').get_item, 'high')
local Lines       = p.create_part(require('hardline.parts.line').get_item, 'warning')
local ListInfos   = p.create_part(listinfos, 'warning')
local Context     = p.create_part(require('nvim-navic').get_location, 'warning')

local Statusline = {
  Mode,
  Git,
  Dirname,
  Align,
  LspError,
  LspWarning,
  Whitespace,
  Filetype,
  Lines,
  ListInfos,
}

local Winbar = {
  Filename,
  Align,
  Context,
}

local TablineFileName = {
  provider = function(self)
    return p.get_tabline_filename(self.tabnr)
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

local TablineFileNameBlock = {
  hl = function(self)
    if self.is_active then
      return "CurSearch"
    else
      return "TabLine"
    end
  end,
  TablineFileName,
}

heirline.setup({
  statusline = { Statusline },
  winbar = { Winbar },
  tabline = { utils.make_tablist(TablineFileNameBlock) },
  opts = {
    disable_winbar_cb = function(args)
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix", "terminal", },
        filetype = { "^git.*", "fugitive", "Trouble", "packer", "fugitiveblame", },
      }, args.buf)
    end,
  },
})
