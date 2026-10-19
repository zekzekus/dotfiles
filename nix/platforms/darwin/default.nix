{
  pkgs,
  config,
  common,
  ...
}: {
  imports = [
    ./modules/aerospace.nix
    ./modules/jankyborders.nix
  ];

  home = {
    packages = with pkgs; [
      glibtool
    ];

    file = {
      ".config/karabiner".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/macosx/karabiner";
      ".hammerspoon/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${common.dotfilesDir}/macosx/hammerspoon/init.lua";
    };

    sessionPath = [
      "/opt/homebrew/bin"
      "/usr/local/bin" # Determinate Nix installs determinate-nixd here.
    ];

    sessionVariables = {
      HOMEBREW_NO_INSTALL_CLEANUP = 1;
    };
  };

  programs.bash.enable = true;
}
