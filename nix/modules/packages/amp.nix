{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789810725-gc77cb3";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "ab3f490f5f7f57d30d945a749a2318163f88d0fa52db91d09f72e9f460ad0f55";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "bb3f14f07b43ab63f1f1ad0521a2dfa881e57aa4d4653366a790e70ddcef4d62";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "c7be4d70ae4c26ce1e85b2a888e8b554f36d08a5ca4c623dc2fbf4f9f8eb7c6c";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "4cb46728ac863c389f226fb31be13a22cc86d0dbb130131aece1874418d135f4";
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
