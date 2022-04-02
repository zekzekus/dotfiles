local hardline = prequire('hardline')

if not hardline then
  return
end

local vimfn = vim.fn
local function listinfos()
  local qflistlen = #vimfn.getqflist()
  local qflist = ''
  if qflistlen > 0 then
    qflist = 'Q:' .. tostring(qflistlen)
  end

  local loclistlen = #vimfn.getloclist(vimfn.winnr())
  local loclist = ''
  if loclistlen > 0 then
    loclist = 'L:' .. tostring(qflistlen)
  end

  if qflistlen > 0 and loclistlen > 0 then
    return qflist .. ' ' .. loclist
  else
    return qflist .. loclist
  end
end

hardline.setup {
  bufferline = false,  -- enable bufferline
  bufferline_settings = {
    exclude_terminal = false,  -- don't show terminal buffers in bufferline
    show_index = false,        -- show buffer indexes (not the actual buffer numbers) in bufferline
  },
  theme = 'default',   -- change theme
  sections = {         -- define sections
    {class = 'mode', item = require('hardline.parts.mode').get_item},
    {class = 'high', item = require('hardline.parts.git').get_item, hide = 100},
    {class = 'med', item = require('hardline.parts.filename').get_item},
    '%<',
    {class = 'med', item = '%='},
    {class = 'low', item = require('hardline.parts.wordcount').get_item, hide = 100},
    {class = 'error', item = require('hardline.parts.lsp').get_error},
    {class = 'warning', item = require('hardline.parts.lsp').get_warning},
    {class = 'warning', item = require('hardline.parts.whitespace').get_item},
    {class = 'high', item = require('hardline.parts.filetype').get_item, hide = 60},
    {class = 'mode', item = require('hardline.parts.line').get_item},
    {class = 'warning', item = listinfos},
  },
}
