local heirline = prequire('heirline')
local conditions = prequire('heirline.conditions')
local common = prequire('hardline.common')
local main_theme = prequire('hardline.themes.default')
local fmt = string.format

local vim = vim

if not heirline then
  return
end

local function get_filename()
  return vim.fn.expand('%:~:.')
end

local function get_dirname()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
end

local function get_readonly()
  if vim.bo.readonly then
    return '[RO]'
  end
  return ''
end

local function get_modified()
  if vim.bo.modified then
    return '[+]'
  end
  if not vim.bo.modifiable then
    return '[-]'
  end
  return ''
end

local function get_fileinfo()
  local name = get_filename()
  local flags = table.concat({get_readonly(), get_modified()})
  if flags ~= '' then
    flags = ' ' .. flags
  end
  return table.concat({name, flags})
end

local create_part = function(item_fn, class)
  return {
    provider = function()
      local item = item_fn()
      if item == '' then
        return item
      end
      return fmt(' %s ', item_fn())
    end,
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

local Align = { provider = "%=" }
local Mode = create_part(require('hardline.parts.mode').get_item, 'mode')
local Git = create_part(require('hardline.parts.git').get_item, 'high')
local Filename = create_part(get_fileinfo, 'warning')
local Dirname = create_part(get_dirname, 'med')
local WordCount = create_part(require('hardline.parts.wordcount').get_item, 'med')
local LspError = create_part(require('hardline.parts.lsp').get_error, 'warning')
local LspWarning = create_part(require('hardline.parts.lsp').get_warning, 'warning')
local Whitespace = create_part(require('hardline.parts.whitespace').get_item, 'warning')
local Filetype = create_part(require('hardline.parts.filetype').get_item, 'high')
local Lines = create_part(require('hardline.parts.line').get_item, 'warning')
local ListInfos = create_part(listinfos, 'warning')
local Context = create_part(require('hardline.parts.treesitter-context').get_item, 'warning')

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
  Filename,
  Align,
  Context,
}

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

heirline.setup({
  statusline = {Statusline},
  winbar = {Winbar},
})
