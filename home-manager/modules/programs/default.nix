{ ... }:

{
  imports = [
    ./carapace.nix
    ./delta.nix
    ./difftastic.nix
    ./direnv.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./jujutsu.nix
    ./mercurial.nix
    ./neovim.nix
    ./nix-helper.nix
    ./nix-your-shell.nix
    ./nushell.nix
    ./starship.nix
    # ./tmux.nix
    ./zoxide.nix
    ./yazi.nix
    ./gpg.nix
  ];

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    btop.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gh.enable = true;
    java.enable = true;
    jjui.enable = true;
    ripgrep.enable = true;
    lazygit.enable = true;
  };
}
