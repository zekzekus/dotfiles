{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780728302-ge188e5";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "500c6316212935fb22be95c11257879dc71dfdf5cec9e00a9bc3197f5693bdfc";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "5d090c9655b5f71ad2ffbec663bbacc9968c6acf1000ddeadd79315ba4191607";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "0e5f9c2e0ff02e5f06049f497673deb06211c35346bcb9321b59b8da1d1689e5";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "5a79bfeaee0bc5db1fcd9073b5b2aa85a66fe3651f6708b614d527fbe02fbef9";
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
