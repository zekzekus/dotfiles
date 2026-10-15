{pkgs}: let
  pname = "grok-bot";
  version = "0.71.2";
  revision = "92808c0ad869b2e3725dbc3b8fa2fcc991687502";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/${revision}/linux/x64/Grok_Bot_${version}.AppImage";
    hash = "sha256-a8SI+sg9tWbojxx1BzkBLbceGPS8Z+af6Tz/M0nZH+g=";
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
