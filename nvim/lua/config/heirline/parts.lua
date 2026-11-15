local prequire = require('utils').prequire

local common      = prequire('hardline.common')
local main_theme  = prequire('config.heirline.zekus_theme_light')
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
    local _, mtch = string.match(file, 'term:(.*):(%a+)')
    retval = mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ':t')
  elseif file == '' then
    retval = '[No Name]'
  else
    if #buflist > 1 then
      retval = fmt('buffers (%s)', #buflist)
    else
      retval = vim.fn.pathshorten(vim.fn.fnamemodify(file, ':p:~:t'))
    end
  end
  return fmt(' [%s] %s ', tabnr, retval)
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

local function get_diagnostic(prefix, severity)
  local count
  if vim.fn.has('nvim-0.6') == 0 then
    count = vim.lsp.diagnostic.get_count(0, severity)
  else
    local severities = {
      ['Warning'] = vim.diagnostic.severity.WARN,
      ['Error'] = vim.diagnostic.severity.ERROR,
    }
    count = #vim.diagnostic.get(0, {severity=severities[severity]})
  end
  if count < 1 then
    return ''
  end
  return fmt('%s:%d', prefix, count)
end

M.get_lsp_errors = function()
  return get_diagnostic('E', 'Error')
end

M.get_lsp_warnings = function()
  return get_diagnostic('W', 'Warning')
end

M.get_lsp_clients = function()
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    return 'none'
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return table.concat(c, '|')
end

return M
