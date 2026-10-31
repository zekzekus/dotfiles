{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793363705-g5c9ae5";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "c6e6f9e61b54db0971116177596518053582924f405b858cc318669a180793df";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "af60f1d306343191a8472e9a0ce719ab41010fe699738ac1c10ef0f531b96ecc";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "f34abc1bcf945238e1c4518bca958475c919a88718b7c54c5a6cdf4f01334c57";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "eb3fd4a0cb9b287441384d304717a5f2845f03095ed5271ddf39e28c7c40f495";
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
