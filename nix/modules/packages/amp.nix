{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779453684-ga69698";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "d897fc6f2a63f25ce49c0015d6b0fef2ec31aa9ff47eeb9379388c9c3aff9004";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "72e28f2e26bec96f5eda2933b20f265cf791fba297a67e6bb928be6a588246dc";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "718547b876ce65e86ce16bfa659831056964a572c54022c320cb2fee763b1077";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "2e7a31bdd0b0576180115dd1ab69816072ab0388b3a31d9ce242e389f933d250";
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
