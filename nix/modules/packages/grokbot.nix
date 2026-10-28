{pkgs}: let
  pname = "grok-bot";
  version = "0.77.0";
  revision = "fe85646036572e2b9a531b337a0dcb56a32f9369";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/${revision}/linux/x64/Grok_Bot_${version}.AppImage";
    hash = "sha256-bRFbuv9M9mlvA1T5sOAj/aa/6pwtMmy1Wd9gpgBaJVc=";
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
