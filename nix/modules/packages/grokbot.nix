{pkgs}: let
  pname = "grok-bot";
  version = "1.2.0";
  revision = "cf0aa5097b8fdfea8f2ecd33ce9f71a72655ef08";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/${revision}/linux/x64/Grok_Bot_${version}.AppImage";
    hash = "sha256-FDbieiUpGpc1o30ItUEKaK5nO7odXQ3GOwEEIaX/mWY=";
  };

  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/grok-bot.desktop $out/share/applications/grok-bot.desktop
      substituteInPlace $out/share/applications/grok-bot.desktop \
        --replace-fail 'Exec=AppRun ' "Exec=$out/bin/grok-bot "
      install -Dm644 ${appimageContents}/grok-bot.png $out/share/icons/hicolor/512x512/apps/grok-bot.png
    '';

    meta = with pkgs.lib; {
      description = "Grok Bot desktop agent";
      homepage = "https://x.ai/bot";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "grok-bot";
    };
  }
