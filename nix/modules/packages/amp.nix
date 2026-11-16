{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1794830433-g119204";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "fd6ddfc84287273cccd824f0c811b9137bf236f7b3ac9bb7f6ebb0b53abfbb5d";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "d2c54a7d6179aff56e65b1f476bacf283e6453cc399866bab5a4ac138188cc22";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "d9f365b820814da41ac4772df94fba5d74440252586bb983244e6e9a8e3cd5d2";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "bf8e6891fba3bb62f8eae6daee96badf18db5b6a120544afd567133b6af504d0";
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
