{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793952045-g82bb22";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "9b71637458e1b9219af44e659f11203c991bad9dce36670d41e645bc2c342a48";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "b3b10070d057dd322a88b65dccfdcd53ed3da080e966e7f50f0fdc55c4840467";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "67fdf47aa69db6f6da48f13b22d20c93aaa726d7f6b1d2d97ccf7972643a9893";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "c0e775dca1ea84f2bc830019af400bab1a16f3ee5986405ff4c8351e1498f444";
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
