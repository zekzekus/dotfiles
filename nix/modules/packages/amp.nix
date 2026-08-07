{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786090945-g2d4407";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "4eb6fd67e4769b60fdf2e27ec9b9e0a6aba500957d81381134510fbba86a857f";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "52c5fc49c3135fb7b8d8c585ca5c66f3bee72c062d77ba80f1ca8dcac2aad15f";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e96de472bc8508ee25ae4db2156d087627344051a2e45e8cba72ec6f64193b09";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "2d4e40ca2960474d7273ee7a8700ca41492e83e089e949b9b58b61bf66a627e4";
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
