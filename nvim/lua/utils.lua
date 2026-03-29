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

M.redir = function(opts)
  local cmd = opts.args
  local range = opts.range
  local line1 = opts.line1
  local line2 = opts.line2

  for win = 1, vim.fn.winnr('$') do
    if vim.fn.getwinvar(win, 'scratch') == 1 then
      vim.cmd(win .. 'windo close')
    end
  end

  local output
  if cmd:match('^!') then
    local shell_cmd = cmd:match('^!(.+)')
    if shell_cmd:match('%%') then
      shell_cmd = shell_cmd:gsub('%%', vim.fn.expand('%:p'))
    end
    if range == 0 then
      output = vim.fn.systemlist(shell_cmd)
    else
      local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
      local joined = table.concat(lines, '\n')
      output = vim.fn.systemlist(shell_cmd, joined)
    end
  else
    output = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, '\n')
  end

  vim.cmd.vnew()
  vim.w.scratch = 1
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

M.grep = function(opts)
  local args = opts.args
  local expanded = vim.fn.expandcmd(args)
  local result = vim.fn.system(vim.o.grepprg .. ' ' .. expanded)
  vim.fn.setqflist({}, ' ', { lines = vim.split(result, '\n') })
  vim.cmd.cwindow()
end

return M
