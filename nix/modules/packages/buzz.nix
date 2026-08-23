{pkgs}: let
  pname = "buzz-desktop";
  version = "0.5.18";

  src = pkgs.fetchurl {
    url = "https://github.com/block/buzz/releases/download/desktop-v${version}/Buzz_${version}_amd64.deb";
    hash = "sha256-esdKHM8l2Gypn5rpt5rlKjXRYljFFx4TnQ9CJpAA3NY=";
  };
in
  pkgs.stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      dpkg
      wrapGAppsHook3
    ];

    buildInputs = with pkgs; [
      alsa-lib
      cairo
      gdk-pixbuf
      glib
      gtk3
      libsoup_3
      openssl
      webkitgtk_4_1
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
      stdenv.cc.cc.lib
    ];

    dontConfigure = true;
    dontBuild = true;
    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall
      dpkg-deb -x $src $out
      mv $out/usr/bin $out/bin
      mv $out/usr/share $out/share
      rmdir $out/usr
      runHook postInstall
    '';

    postFixup = ''
      wrapGApp $out/bin/buzz-desktop \
        --set-default BUZZ_RELAY_URL wss://blockbuzzmain-production-c520.up.railway.app \
        --set-default GDK_BACKEND x11 \
        --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    '';

    meta = with pkgs.lib; {
      description = "Workspace for human and AI agent teams";
      homepage = "https://buzz.xyz";
      license = licenses.asl20;
      platforms = ["x86_64-linux"];
      mainProgram = "buzz-desktop";
    };
  }
