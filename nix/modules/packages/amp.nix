{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785833597-ge3f010";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "34987921c33fa58c018ef62ba61dc58a62f31e6e72bce279dfc675238bc0fd02";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0f596f4d89c6f66237a1abbb63963754d8093cd89788af2a9f9fe9b65d7437a3";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "15d25f49d283f6d96deb635fc3b84548c71a4045caddcde66fbe16036bfba0e9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "23eba136193d5dc506e6bf5b5185cd171bde36e6f2d3c66abf903755bb6f2a62";
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
