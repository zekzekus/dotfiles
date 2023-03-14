local common      = prequire('hardline.common')
local main_theme  = prequire('hardline.themes.default')
local conditions  = prequire('heirline.conditions')

local fmt = string.format

local M = {}

local vim = vim

M.get_filename = function()
  return vim.fn.expand('%:~:.')
end

M.get_tabline_filename = function(tabnr)
  local buflist = vim.fn.tabpagebuflist(tabnr)
  local winnr = vim.fn.tabpagewinnr(tabnr)
  local bufnr = buflist[winnr]

  local file = vim.fn.bufname(bufnr)
  local buftype = vim.fn.getbufvar(bufnr, '&buftype')
  local filetype = vim.fn.getbufvar(bufnr, '&filetype')

  local retval = ""
  if buftype == 'help' then
    retval = 'help:' .. vim.fn.fnamemodify(file, ':t:r')
  elseif buftype == 'quickfix' then
    retval = 'quickfix'
  elseif filetype == 'TelescopePrompt' then
    retval = 'Telescope'
  elseif filetype == 'git' then
    retval = 'Git'
  elseif filetype == 'fugitive' then
    retval = 'Fugitive'
  elseif file:sub(file:len()-2, file:len()) == 'FZF' then
    retval = 'FZF'
  elseif buftype == 'terminal' then
    local _, mtch = string.match(file, "term:(.*):(%a+)")
    retval = mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ':t')
  elseif file == '' then
    retval = '[No Name]'
  else
    if #buflist > 1 then
      retval = fmt("buffers (%s)", #buflist)
    else
      retval = vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
    end
  end
  return fmt(" [%s] %s ", tabnr, retval)
end

M.get_dirname = function()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
end

M.get_readonly = function()
  if vim.bo.readonly then
    return '[RO]'
  end
  return ''
end

M.get_modified = function()
  if vim.bo.modified then
    return '[+]'
  end
  if not vim.bo.modifiable then
    return '[-]'
  end
  return ''
end

M.create_part = function(item_fn, class)
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

return M
