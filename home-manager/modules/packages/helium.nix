{pkgs}: let
  pname = "helium";
  version = "0.8.2.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-abNHp4WaR2MqidG42TErJZBR1PcUVtRpBYFiKCmadW8=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Install desktop file
      install -Dm644 ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
      substituteInPlace $out/share/applications/helium.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=helium'

      # Install icons
      for size in 16 32 48 64 128 256 512; do
        icon="${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/helium.png"
        if [ -f "$icon" ]; then
          install -Dm644 "$icon" "$out/share/icons/hicolor/''${size}x''${size}/apps/helium.png"
        fi
      done

      # Fallback: try to find any icon
      if [ -f "${appimageContents}/helium.png" ]; then
        install -Dm644 ${appimageContents}/helium.png $out/share/icons/hicolor/256x256/apps/helium.png
      fi
    '';

    meta = with pkgs.lib; {
      description = "Privacy-focused browser with ad-blocking by default";
      homepage = "https://helium.computer";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "helium";
    };
  }
