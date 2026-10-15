{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1792051250-g2fc5c0";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "1df66499242259c9a933969dfe67173dff170684ad3ac0853cbe58a4a9391bbb";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "da6dcfbc9f8698b0f4e18fe99cc379668c0af4bb5b6cd3937a99d880bb1b03a0";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "6b825a7da8b6763200e45eca21bcd8b2c81aa6b2c73546e6b2b76cb04f996c80";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "082a48001bf1385c545850dbb8482df8fef5b5398dd2e5a3430816a3bfd010c1";
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
