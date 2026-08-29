{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788022426-gb1510d";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "5cb550412f00d4b045259c21ca4cb2fc8222a51d50c44703c38816f4c5e186e2";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "eda5379dda00e9c7aa9343f808ad02005e48181e73f38c84fb7c7d037cccf6d9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "66dd329b3cd12187561786d3b485bc479cf4c927f3a53e232ce6a013b42aca3b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "0de3f36ba746bf2566a744fcac8c8c5f39304eb3e8d98f52d8acd5d885b4be67";
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
