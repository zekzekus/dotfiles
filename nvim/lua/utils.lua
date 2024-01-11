_G.prequire = function(plugin, verbose)
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

_G.default_config = function(plugin)
  local plug = prequire(plugin)
  if not plug then
    return
  end
  plug.setup({})
end

local vimfn = vim.fn
_G.listinfos =  function()
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

