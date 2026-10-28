{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793119929-g574f34";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "93580139eb3eaa29d70530ef7e2a2f05717bff09c6cb7ab5e5e67d95aa1c42d6";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "816f476f92bda02833c5fbff84552c75b88dff8749f242391452019e95a84c18";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "0ab755e8cf38128170b7d37be5771d3d09a1e90b7428d8e3a4eec8fededc7af2";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "0c46292fc4f7d5a45f3993b7c21d430f2eeefc72354c60d471a1b306c38f7c49";
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
