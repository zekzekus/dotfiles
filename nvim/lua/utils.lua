local M = {}

M.prequire = function(plugin, verbose)
  local present, plug = pcall(require, plugin)
  if present then
    return plug
  end
  local errmsg = string.format('Could not load %s', plugin)
  if verbose then
    errmsg = string.format('\nError:%s', plug)
  end
  print(errmsg)
end

M.default_config = function(plugin)
  local plug = M.prequire(plugin)
  if not plug then
    return
  end
  plug.setup({})
end

local vimfn = vim.fn

M.open_junkfile = function(ext)
  local junkdir = vimfn.expand('~/.cache/junkfile')
  ext = (ext and ext ~= '') and ext or 'txt'
  local filename = os.date('%Y-%m-%d-%H%M%S.') .. ext
  local path = junkdir .. '/' .. filename

  vimfn.mkdir(junkdir, 'p')
  if vimfn.filereadable(path) == 0 then
    vimfn.writefile({}, path)
  end

  vim.cmd.edit(vimfn.fnameescape(path))
end

M.listinfos =  function()
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

return M
