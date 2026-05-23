{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779547160-g4a1cc9";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "ac8c59e03323e4b6940136d76ecc1965f59a828c2154e9544eae4cf6f9be667a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "8effa0e660eaa46d1b84e17f707718019e79e94571dd111a4d24018f9770549c";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "cb33a4d0dce4f2db69edb643c725c23a363de40ee65f0c29b01aefb878ee3462";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "ff28cdbe8a6c4e80bbf6a52e04cd7048f9a9bea3c144b0586cd24fc8e56874db";
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
