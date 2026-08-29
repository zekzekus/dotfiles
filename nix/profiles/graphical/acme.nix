{pkgs, ...}: let
  plan9 = pkgs.plan9port.overrideAttrs (old: {
    postPatch = ''
      ${old.postPatch or ""}
      substituteInPlace src/cmd/devdraw/x11-screen.c \
        --replace-fail 'return 1<<(b-1);' 'return mouseswap(1<<(b-1));'
    '';
  });
  acme = pkgs.writeShellScriptBin "acme" ''
    export mousebuttonmap=12345672
    export SHELL=${plan9}/plan9/bin/rc
    export EDITOR=${plan9}/plan9/bin/E
    exec ${plan9}/bin/9 acme \
      -a \
      -f /mnt/font/TX-02-Regular/18a/font \
      -F /mnt/font/TX-02-Regular/18a/font \
      "$@"
  '';
  desktopItem = pkgs.makeDesktopItem {
    name = "acme";
    desktopName = "Acme";
    genericName = "Text Editor";
    comment = "Plan 9 text editor and development environment";
    exec = "${acme}/bin/acme";
    icon = "${plan9}/plan9/dist/glendacircle.png";
    categories = ["Development" "TextEditor"];
    terminal = false;
  };
in {
  home.packages =
    [
      plan9
      acme
    ]
    ++ pkgs.lib.optional pkgs.stdenv.hostPlatform.isLinux desktopItem;
}
