{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789549843-gf041d8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "80b20ad1768727f4904ca9e59b1865a87bb1cfe955159366175cac8c241bf75c";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "3f9cff5f9d63f0143fa1b31970d80c618e3bad1c2914f473d2240f7cda9a1243";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "f325ae2377e5f451f3474335a55788086c95c1bc427431195545131062dc57db";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "d829f1a74813b4a7d14871c6bbc76bb7eafd6ada022685414368b2e9b39fa4fd";
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
