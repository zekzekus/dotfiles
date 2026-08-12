{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786565549-g82d377";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "a7057e6a483bb0ba6d36adc269e2d2ec5dff6ddce7c3eed5a7a6f56a4257f212";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "fb79a9314d01f63ec20622847f76005dcac233cda49bd25fb677fc490a509560";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "449ac2e3d438f34c36dc87a2ccf53b6a7b4895d149713680ce2bf8595ea35be3";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "ace6deecd0cf463b697b72a1872deb00f5a81ccf4efeb7f0aedfbe5bd2b741c6";
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
