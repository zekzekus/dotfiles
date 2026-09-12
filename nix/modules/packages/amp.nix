{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789228846-g1b23f3";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "b483c823f45b7014698b36d7ca0ca7dc61b4aa4969c92150eb8cdba3d3bfb913";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "9c3f28bda559fab8eb16dea5fd142b58acdc33bc12f524b4405de58abbe27f16";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "1d268fd457d95630d708cf82ef61968663a6722cdcc088ec4db1f520d2f7efcc";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "8ef64680f5b1437a9c038642f342677e6f89660adfd89fecc466c3e95661ea19";
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
