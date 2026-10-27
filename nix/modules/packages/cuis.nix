{pkgs}: let
  inherit (pkgs) lib;
  linux = pkgs.stdenv.hostPlatform.isLinux;
  version = "7.9-8257";
  src = pkgs.fetchzip {
    url = "https://github.com/Cuis-Smalltalk/Cuis-Smalltalk-Dev/archive/d717ca00b02dd0f1d270d21133c3a855158d6cc9.tar.gz";
    hash = "sha256-CcA97XPGb3rvYRpco5mx3nQkZQ6lZpzKE4Lnc8GUAtA=";
  };
  desktopItem = pkgs.makeDesktopItem {
    name = "cuis";
    desktopName = "Cuis Smalltalk";
    genericName = "Smalltalk Development Environment";
    exec = "cuis";
    icon = "cuis";
    startupWMClass = "Squeak";
    categories = ["Development" "IDE"];
    terminal = false;
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "cuis-smalltalk";
    inherit version src;

    nativeBuildInputs = lib.optionals linux [pkgs.autoPatchelfHook pkgs.libicns];
    buildInputs = lib.optionals linux (with pkgs; [
      alsa-lib
      cairo
      glib
      harfbuzz
      libGL
      libice
      libpulseaudio
      libsm
      libuuid
      libx11
      libxext
      libxrender
      nas
      pango
      sndio
      zlib
    ]);
    # SqueakSSL loads OpenSSL at runtime, rather than declaring ELF dependencies.
    runtimeDependencies = lib.optionals linux [pkgs.openssl.out];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchShebangs = true;

    installPhase =
      ''
        runHook preInstall
        mkdir -p "$out/share/cuis" "$out/bin" "$out/libexec"
        cp -R CuisImage CoreUpdates Packages CompatibilityPackages Documentation TrueTypeFonts "$out/share/cuis/"
        rm -r "$out/share/cuis/CuisImage/32BitsImage"
        mv "$out/share/cuis/CuisImage/Cuis${version}.image" "$out/share/cuis/CuisImage/Cuis.image"
        mv "$out/share/cuis/CuisImage/Cuis${version}.changes" "$out/share/cuis/CuisImage/Cuis.changes"
        cp LICENSE "$out/share/cuis/"
      ''
      + lib.optionalString linux ''
        cp -R CuisVM.app/Contents/Linux-x86_64/lib/squeak/* "$out/libexec/vm"
        install -Dm644 ${desktopItem}/share/applications/cuis.desktop "$out/share/applications/cuis.desktop"
        substituteInPlace "$out/share/applications/cuis.desktop" --replace-fail 'Exec=cuis' "Exec=$out/bin/cuis"
        mkdir -p "$out/share/icons/hicolor/256x256/apps"
        icns2png -x -s 256 CuisVM.app/Contents/Resources/Squeak.icns
        cp Squeak_256x256x32.png "$out/share/icons/hicolor/256x256/apps/cuis.png"
      ''
      + lib.optionalString (!linux) ''
        cp -R CuisVM.app "$out/libexec/"
        rm -r "$out/libexec/CuisVM.app/Contents/"Linux-* "$out/libexec/CuisVM.app/Contents/"Windows-*
        mkdir -p "$out/Applications/Cuis Smalltalk.app/Contents/"{MacOS,Resources}
        cp CuisVM.app/Contents/Resources/Squeak.icns "$out/Applications/Cuis Smalltalk.app/Contents/Resources/"
        cat > "$out/Applications/Cuis Smalltalk.app/Contents/Info.plist" <<'PLIST'
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0"><dict>
          <key>CFBundleExecutable</key><string>Cuis</string>
          <key>CFBundleIdentifier</key><string>org.cuis.Smalltalk</string>
          <key>CFBundleName</key><string>Cuis Smalltalk</string>
          <key>CFBundlePackageType</key><string>APPL</string>
          <key>CFBundleIconFile</key><string>Squeak.icns</string>
          <key>CFBundleShortVersionString</key><string>${lib.replaceStrings ["-"] ["."] version}</string>
        </dict></plist>
        PLIST
        printf '#!${pkgs.runtimeShell}\nexec "%s/bin/cuis" "$@"\n' "$out" > "$out/Applications/Cuis Smalltalk.app/Contents/MacOS/Cuis"
        chmod +x "$out/Applications/Cuis Smalltalk.app/Contents/MacOS/Cuis"
      ''
      + ''
        cat > "$out/bin/cuis" <<'SCRIPT'
        #!${pkgs.runtimeShell}
        set -euo pipefail
        export PATH=${lib.makeBinPath [pkgs.coreutils]}:"$PATH"
        if [[ "''${1:-}" == --help ]]; then
          echo 'Usage: cuis [--headless] [Cuis image arguments, e.g. -s script.st]'
          echo 'CUIS_HOME overrides the writable workspace. Existing images are never replaced.'
          exit 0
        fi
        workspace="''${CUIS_HOME:-${
          if linux
          then "\${XDG_DATA_HOME:-$HOME/.local/share}/cuis"
          else "$HOME/Library/Application Support/Cuis"
        }}"
        if [[ ! -e "$workspace" ]]; then
          mkdir -p "$(dirname "$workspace")"
          staging=$(mktemp -d "$workspace.init.XXXXXX")
          trap 'rm -rf "$staging"' EXIT
          cp -R @out@/share/cuis/. "$staging/"
          chmod -R u+w "$staging"
          mv -T "$staging" "$workspace"
          trap - EXIT
        fi
        if [[ ! -w "$workspace/CuisImage/Cuis.image" || ! -w "$workspace/CuisImage/Cuis.changes" ]]; then
          echo "Cuis: expected writable CuisImage/Cuis.image and Cuis.changes in $workspace" >&2
          exit 1
        fi
        cd "$workspace"
        vmArgs=()
        if [[ "''${1:-}" == --headless ]]; then
          vmArgs+=(${
          if linux
          then "-vm-display-null -vm-sound-null"
          else "-headless"
        })
          shift
        fi
        ${lib.optionalString linux ''
          export SQUEAK_PLUGINS=@out@/libexec/vm
          export SQUEAK_DISPLAY_PER_MONITOR_SCALE=1
        ''}
        exec @out@/${
          if linux
          then "libexec/vm/squeak -encoding UTF-8"
          else "libexec/CuisVM.app/Contents/MacOS/Squeak"
        } "''${vmArgs[@]}" "$workspace/CuisImage/Cuis.image" -ud "$workspace/UserFiles" "$@"
        SCRIPT
        substituteInPlace "$out/bin/cuis" --replace-fail '@out@' "$out"
        chmod +x "$out/bin/cuis"
        runHook postInstall
      '';

    doInstallCheck = linux;
    installCheckPhase = ''
      runHook preInstallCheck
      export CUIS_HOME="$TMPDIR/cuis test"
      timeout 30 "$out/bin/cuis" --headless -d \
        'Smalltalk at: #CuisInstallProbe put: 42. Smalltalk snapshot: true andQuit: true embedded: false clearAllClassState: false'
      timeout 30 "$out/bin/cuis" --headless -d \
        'Smalltalk quitPrimitive: ((Smalltalk at: #CuisInstallProbe ifAbsent: [0]) = 42 ifTrue: [0] ifFalse: [1])'
      runHook postInstallCheck
    '';

    meta = {
      description = "Cuis Smalltalk with a persistent, writable personal image";
      homepage = "https://cuis.st/";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux" "aarch64-darwin"];
      mainProgram = "cuis";
    };
  }
