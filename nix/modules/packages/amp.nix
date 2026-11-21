{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1795276835-g0feb0c";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "7ba5abd00376945e726fafb13dca45e9e00b2db66d43951954109cc1b2f44824";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "1a0b67aebd0d0620a0cb76feb7de36e23a514ef938359821d4bb8d527350b38b";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "98be27903234e9048f60236a565aed4134d3f3049b1f359c3d0ff561c3da6adb";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "1fe767d0db40a5f637b8a89d1f5777c7a98343f7b424fd43b3786ccdaae3dcb7";
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
