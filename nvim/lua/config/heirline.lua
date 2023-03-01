local heirline    = prequire('heirline')
local conditions  = prequire('heirline.conditions')
local utils       = prequire('heirline.utils')

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
local WordCount   = p.create_part(require('hardline.parts.wordcount').get_item, 'med')
local LspError    = p.create_part(require('hardline.parts.lsp').get_error, 'warning')
local LspWarning  = p.create_part(require('hardline.parts.lsp').get_warning, 'warning')
local Whitespace  = p.create_part(require('hardline.parts.whitespace').get_item, 'warning')
local Filetype    = p.create_part(require('hardline.parts.filetype').get_item, 'high')
local Lines       = p.create_part(require('hardline.parts.line').get_item, 'warning')
local ListInfos   = p.create_part(listinfos, 'warning')
local Context     = p.create_part(require('hardline.parts.treesitter-context').get_item, 'warning')

local Statusline = {
  Mode,
  Git,
  Dirname,
  Align,
  WordCount,
  LspError,
  LspWarning,
  Whitespace,
  Filetype,
  Lines,
  ListInfos,
}

local Winbar = {
  {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "prompt", "nofile", "help", "quickfix", "terminal" },
        filetype = { "gitcommit", "fugitive", "fugitiveblame" }
      })
    end,
    init = function()
      vim.opt_local.winbar = nil
    end
  },
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
  tabline = { utils.make_tablist(TablineFileNameBlock) }
})

vim.api.nvim_create_autocmd("User", {
  pattern = 'HeirlineInitWinbar',
  callback = function(args)
    local buf = args.buf
    local buftypes = { "prompt", "nofile", "help", "quickfix" }
    local buftype = vim.tbl_contains(
      buftypes,
      vim.bo[buf].buftype
    )

    local filetypes = { "gitcommit", "fugitive", "fugitiveblame" }
    local filetype = vim.tbl_contains(filetypes, vim.bo[buf].filetype)

    if buftype or filetype then
      vim.opt_local.winbar = nil
    end
  end,
})
