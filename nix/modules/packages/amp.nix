{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1782145303-gaa0ecf";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "b549545f95de730b93fdb507edb058477e731098af1feb8b5f384531b7fe590c";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "4af18e1b7c13620bcdbf9beda7208e131d58b513fe9e545e5a966657b7b198ea";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "107549fdca2fcdd6751b3322807f0981e6647d8e5bc29548a07c721677a6a095";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "bc9a9e082d8759f61fb108cfd8c8ae47d491817a9c66d2dc53373eadec89ac37";
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
