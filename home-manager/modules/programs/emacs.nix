{
  pkgs,
  common,
  lib,
  ...
}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;

    extraPackages = epkgs:
      with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
        pdf-tools
      ];
  };

  home.packages = with pkgs; [
    # Doom Emacs dependencies
    git
    ripgrep
    fd
    coreutils

    # For native compilation
    gcc
    binutils

    # For vterm
    cmake
    libtool

    # Fonts (for icons)
    emacs-all-the-icons-fonts
    nerd-fonts.symbols-only

    # Org-roam sqlite
    sqlite

    # LaTeX support
    texliveFull

    # Markdown/Pandoc
    pandoc

    # For +hugo
    hugo

    # Spell checking
    (aspellWithDicts (dicts: with dicts; [en en-computers en-science]))

    # PDF tools deps
    poppler-utils
  ];

  home.sessionPath = ["$HOME/.config/emacs/bin"];

  home.file.".config/doom".source = "${common.dotfilesDir}/misc/emacs/doom";

  home.activation.installDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    fi
  '';
}
