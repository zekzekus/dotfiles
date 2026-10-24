{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1792828848-gc7cca4";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "edc0da22440b8c4af5272e6a6d0bb353025d0da63134037a1d7d3ce0a0a6c7c7";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "6dd4e1e65a2005ba72c9b44e27d20330a1dc5ea13e5da119724e56327aced3ba";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "0cd18c56e597cb7bf8e547d0c2d6645921ea7ad7b5755287e6b987938ae27eca";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "757a4ac8bb403b477eba4a4509d3e2d23841177d7a9b1ff629f559b19d4c3985";
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
