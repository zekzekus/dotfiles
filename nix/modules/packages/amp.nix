{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787472205-g6b050c";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "fa8091f49b30ecea0bb81a6a7b0d3cfca28fabd3a5590fccac952b7ede67011d";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "83c03c861d862bac9851d7c74d2c7500c47d255bc69fb0473d70300a6bb8dba8";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "6fc92561db34389100e32f2691a98d6e3939946de6359b5c7df7e70479f582c9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "3251bc486db6e96ec040f5482f9da764eabf544796f0fa222a0f6f1c4249cf93";
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
