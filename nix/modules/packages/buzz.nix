{pkgs}: let
  pname = "buzz-desktop";
  version = "0.5.5";

  src = pkgs.fetchurl {
    url = "https://github.com/block/buzz/releases/download/desktop-v${version}/Buzz_${version}_amd64.AppImage";
    hash = "sha256-zFHK2mN9YZcSHpXwgyisGcu/7t0+mSIotVLPQ4k+K90=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/usr/bin/buzz-desktop \
        --replace-fail \
          'exec -a "buzz-desktop"' \
          $'export GST_PLUGIN_SYSTEM_PATH_1_0=/usr/lib/gstreamer-1.0\nexec -a "buzz-desktop"'
      substituteInPlace $out/AppRun \
        --replace-fail \
          'set -e' \
          $'set -e\n\nif [[ -n "''${BUZZ_APPIMAGE_COMMAND:-}" ]]; then\n  exec "$BUZZ_APPIMAGE_COMMAND" "$@"\nfi'
    '';
  };
in
  pkgs.appimageTools.wrapAppImage {
    inherit pname version;
    contents = appimageContents;
    nativeBuildInputs = [pkgs.makeWrapper];
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
      install -Dm644 ${appimageContents}/Buzz.png \
        $out/share/icons/hicolor/256x256/apps/buzz-desktop.png

      makeWrapper $out/bin/buzz-desktop $out/bin/buzz \
        --set BUZZ_APPIMAGE_COMMAND ${appimageContents}/usr/bin/buzz
      makeWrapper $out/bin/buzz-desktop $out/bin/git-credential-nostr \
        --set BUZZ_APPIMAGE_COMMAND ${appimageContents}/usr/bin/git-credential-nostr
    '';

    meta = with pkgs.lib; {
      description = "Workspace for human and AI agent teams";
      homepage = "https://buzz.xyz";
      license = licenses.mit;
      platforms = ["x86_64-linux"];
      mainProgram = "buzz-desktop";
    };
  }
