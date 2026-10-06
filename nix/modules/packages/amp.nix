{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1791302439-g888480";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "cb34931b0f55175a4b624f3c3fb46edef4f568cf9c878f667d5dd336fed83441";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "513988bb04809ea788aa924aabfd605f7bc0777072605292884b0ebcef5bf6e1";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "8894cb55e785a292024ed17c9e8e21654c5369bcb96786488473dc04ddb636f3";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "22b5fa991f6b1675a6c0223992b67c9de9aceafb0f9f775ff46c6c6d6d357cfc";
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
