{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1790452833-gea4e33";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "e042f507d10a721890e5d88be911f1bb3816c9b54a7ac906de2cedc8f603cc0b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "2d24609d5bd3ec3b7fd47e5f8dd44ed89a0717c0ae261d32cf0afd045a7103e6";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "3fcba4e3540f0b3debd1e4c207b569cf94c5fc4866332fbea537f6dde71f4c80";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "87a2c772b27d92c01a32313ba4efd0977de1ad4bae477d8efdfe41c0d3a5ff24";
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
