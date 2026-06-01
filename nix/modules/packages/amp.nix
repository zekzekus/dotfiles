{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780291930-gf6d536";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "58ddad23926a4070787a184a53da5ed7590a9f4e5ce0bed2399e1897ddda46c0";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a8a0cb2ca5994e5f7cc94e9a24ce557870a3d4fc358fcb9d269c688763e5a1ae";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "31793eb41a158d0afcedb942bf23c07cfaed61268c19c27fa92b01bb7a2899ba";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "ccb42070c2da5f056c98b400ff07e31470516a33dd5dafc6dce560f48145384f";
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
