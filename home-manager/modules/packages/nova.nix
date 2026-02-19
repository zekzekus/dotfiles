{pkgs}: let
  pname = "nova";
  version = "1.10.0";

  src = pkgs.fetchurl {
    url = "https://github.com/lightmode-laboratories/nova/releases/download/v${version}/Nova-x86_64.AppImage";
    hash = "sha256-EOuL7/2SJ7m5wHT1tH26Gk3Qen70uPP4MS/L64cJ/eg=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Install desktop file with corrected Exec path
      install -Dm644 ${appimageContents}/nova.desktop $out/share/applications/nova.desktop
      substituteInPlace $out/share/applications/nova.desktop \
        --replace-warn "Exec=AppRun --no-sandbox %U" "Exec=nova %U"

      # Install icons
      for size in 16 24 32 48 64 128 256 512; do
        icon="${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/nova.png"
        if [ -f "$icon" ]; then
          install -Dm644 "$icon" "$out/share/icons/hicolor/''${size}x''${size}/apps/nova.png"
        fi
      done

      # Fallback: try root-level icon
      if [ -f "${appimageContents}/nova.png" ]; then
        install -Dm644 ${appimageContents}/nova.png $out/share/icons/hicolor/256x256/apps/nova.png
      fi
    '';

    meta = with pkgs.lib; {
      description = "A futuristic canvas for your personal development";
      homepage = "https://nova.lightmode.io";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
      mainProgram = "nova";
    };
  }
