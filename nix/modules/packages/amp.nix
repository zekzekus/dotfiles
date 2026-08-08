{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786162957-g48b3cf";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "6100c7267d64bcf74eb90f5bb3b3e3c1af5fa2c7af47488537c97ae988810982";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0e90c5009007950c3498f7e7c9d139a53f5e71908d38c173a26f9cb740ad4bf7";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "726368f218edb6c3bc0d07a1d8f0eba3ad3fe8f3fcc1a31fa701e20dd0513119";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "de569ffa01bf43dfcfc7f384efc44339df7c749cabd7c9bc033a561b119fee0b";
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
