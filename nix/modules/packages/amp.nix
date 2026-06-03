{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780478921-g021c3e";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "6445f61e38732d74f81721c76aa3e3e3d8f72e9aa494a9243aea1dd84429a258";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "5b985039b53f78f4900424bd0d64b3ebc255ff220c99baf90c8228b16627c2d4";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "7d2a6ee9b575044932e3af1ded9b593f910838b45f1b3315af51a4a52b9ebe2b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "e68fdd2c5716029e35b648fe92e63d98de6abd06a904083d0cdc566baeba507c";
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
