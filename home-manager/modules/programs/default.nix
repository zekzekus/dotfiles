{ ... }:

{
  imports = [
    ./carapace.nix
    ./delta.nix
    ./difftastic.nix
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./nix-your-shell.nix
    ./nushell.nix
    ./starship.nix
    # ./tmux.nix
    ./zed-editor.nix
    ./zoxide.nix
    ./yazi.nix
  ];

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    btop.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gh.enable = true;
    gpg.enable = true;
    java.enable = true;
    jujutsu.enable = true;
    ripgrep.enable = true;
    lazygit.enable = true;
  };
}
