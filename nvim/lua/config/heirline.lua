local heirline = prequire('heirline')

if not heirline then
  return
end

heirline.setup({
  statusline = {
    { provider = require('hardline.parts.mode').get_item },
    { provider = require('hardline.parts.git').get_item },
    { provider = require('hardline.parts.filename').get_item },
    { provider = "%=" },
    { provider = require('hardline.parts.wordcount').get_item },
    { provider = require('hardline.parts.lsp').get_error },
    { provider = require('hardline.parts.lsp').get_warning },
    { provider = require('hardline.parts.whitespace').get_item },
    { provider = require('hardline.parts.filetype').get_item },
    { provider = require('hardline.parts.line').get_item },
    { provider = listinfos() },
  }
})
