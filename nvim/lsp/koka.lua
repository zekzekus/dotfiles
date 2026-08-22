return {
  cmd = function(dispatchers, config)
    local cmd = { 'koka', '--language-server', '--buildtag=vscode' }
    if config.root_dir then
      table.insert(cmd, '-i' .. config.root_dir)
    end
    table.insert(cmd, '--lsstdio')
    return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
  end,
  filetypes = { 'koka' },
  root_markers = { 'koka.json', '.koka.json', '.git' },
}
