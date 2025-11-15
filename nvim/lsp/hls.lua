return {
  cmd = { 'nix', 'run', '.#hls', '--', '--lsp' },
  filetypes = { 'haskell', 'lhaskell' },
  root_markers = { 'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', '.git' },
}
