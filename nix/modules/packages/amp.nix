{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781166336-g02cc1e";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "a86f863e6a942f233fb84a87c0f227a2d1eb97396b2d07e40c6951dd5d893b46";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "5ddd9c583feec8969485bf43687b508eb15ee29831092f5f61a49bd1d8e186e7";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "56ae4d41a248f2fa0c2c02bc1ed508c8394e4299d16356c521b706a58fb68200";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "55706da2252edf2d9d2d6a2fc7b6dbebcadcde2aefaf40f7675d50ebc8965dd5";
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
