{pkgs}: let
  pname = "buzz";
  version = "0.5.4";

  src = pkgs.fetchurl {
    url = "https://github.com/block/buzz/releases/download/desktop-v${version}/Buzz_${version}_amd64.AppImage";
    hash = "sha256-Aho/xwEzJk9eDFtE2SYmt1Egsdm2REOstXa6jYwAnME=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/usr/bin/buzz-desktop \
        --replace-fail \
          'exec -a "buzz-desktop"' \
          $'export GST_PLUGIN_SYSTEM_PATH_1_0=/usr/lib/gstreamer-1.0\nexec -a "buzz-desktop"'
    '';
  };
in
  pkgs.appimageTools.wrapAppImage {
    inherit pname version;
    contents = appimageContents;
    extraPkgs = pkgs: [
      pkgs.elfutils
      pkgs.zstd
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-libav
    ];
    profile = ''
      export APPIMAGE=${src}
    '';

    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/usr/share/applications/Buzz.desktop \
        $out/share/applications/buzz.desktop
      substituteInPlace $out/share/applications/buzz.desktop \
        --replace-fail "Exec=buzz-desktop" "Exec=buzz"
      install -Dm644 ${appimageContents}/Buzz.png \
        $out/share/icons/hicolor/256x256/apps/buzz-desktop.png
    '';

    meta = with pkgs.lib; {
      description = "Workspace for human and AI agent teams";
      homepage = "https://buzz.xyz";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "buzz";
    };
  }
