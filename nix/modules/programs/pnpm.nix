{common, ...}: {
  xdg.configFile."pnpm/rc".text = ''
    global-bin-dir=${common.homeDir}/.local/share/pnpm
    only-built-dependencies[]=@ampcode/cli
  '';
}
