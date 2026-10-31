{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793476832-ga2d2ae";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "8c43cea70ab7006005ce07c5c5f809b02b6acbf40f41c308524204a6ef51d9a7";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "2f18b8bd010704befeca3968e559dff02051ba0cac840194de1ac5bb0e480b74";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "c3e2a6373bf7fdf09d74da7bf57a3a7f86434da801357df220cbd9dcf557ef97";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "3fb5b0582ccaa938fc900c6ce49e827344034ac14ec397149e80a6d5e3d80faa";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
    or (throw "amp: unsupported system ${stdenv.hostPlatform.system}");
in
  # The Linux binary is a Bun single-file executable: Bun's runtime with the
  # amp script appended as a tail-of-file chunk. autoPatchelfHook / patchelf
  # rewrites that grow the file shift the embedded chunk's offset, so the
  # script bundle can't be found and the binary degrades to plain Bun.
  # Instead, ship the unmodified bytes and rely on nix-ld
  # (programs.nix-ld.enable = true) to provide /lib64/ld-linux-*.so.2.
  stdenv.mkDerivation {
    pname = "amp";
    inherit version;

    src = fetchurl {
      url = "https://static.ampcode.com/cli/${version}/amp-${source.platform}";
      inherit (source) sha256;
    };

    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/amp
      runHook postInstall
    '';

    meta = {
      description = "Amp CLI by Sourcegraph";
      homepage = "https://ampcode.com";
      mainProgram = "amp";
      platforms = builtins.attrNames sources;
    };
  }
