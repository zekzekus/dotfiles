{ pkgs, common, ... }:

{
  home-manager.enable = true;
  bat.enable = true;
  btop.enable = true;
  fd.enable = true;
  fzf.enable = true;
  gh.enable = true;
  gpg.enable = true;
  java.enable = true;
  jujutsu.enable = true;
  ripgrep.enable = true;
  lazygit.enable = true;
  
  git = import ./git.nix { inherit pkgs common; };
  delta = import ./delta.nix { inherit pkgs common; };
  difftastic = import ./difftastic.nix { inherit pkgs common; };
  firefox = import ./firefox.nix { inherit pkgs common; };
  fish = import ./fish.nix { inherit pkgs common; };
  starship = import ./starship.nix { inherit pkgs common; };
  tmux = import ./tmux.nix { inherit pkgs common; };
  zoxide = import ./zoxide.nix { inherit pkgs common; };
  nix-your-shell = import ./nix-your-shell.nix { inherit pkgs common; };
  zed-editor = import ./zed-editor.nix { inherit pkgs common; };

  nushell = {
    enable = true;
    environmentVariables = {
      ZEK_DEVEL_HOME = common.develHome;
      ZEK_DEFAULT_PROJECT_DIR = common.defaultProjectDir;
      ZEK_DEVEL_WORK_HOME = common.workHome;
      ZEK_DEVEL_PERSONAL_HOME = common.personalHome;

      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";

      TMUX_FZF_LAUNCH_KEY = "o";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
      FZF_CTRL_T_COMMAND = "rg --files --hidden --follow --glob \"!.git/*\"";
      FZF_ALT_C_COMMAND = "bfs -type d -nohidden";

      PNPM_HOME = "${common.homeDir}/.local/share/pnpm";
    };
    extraEnv = ''
      $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/.local/share/pnpm')
      $env.PATH = ($env.PATH | split row (char esep) | prepend '${common.homeDir}/bin')
    '';
  };

}
