{pkgs}: let
  pname = "grok-bot";
  version = "0.75.5";
  revision = "e4789bbe423912faa668dc29e013436280428fe6";

  src = pkgs.fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/${revision}/linux/x64/Grok_Bot_${version}.AppImage";
    hash = "sha256-XF72qTA2xn/ualMMSjIl0eCvoWmV2CmXHq8K/sUJaaA=";
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
