{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788638425-g646a48";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "45ec2ac03c18557e9141c834824d34a50de2852be17f66b29b71a6965f0fcb62";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "34fbfa23f70da350c6f6b1a3defe1f75854ee1578c59143d7e38db1e05b47349";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "aa0c3ea47890d2277ee6ccb5f4809750ab97a7d41278e783f7e2721cbd4213af";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "5bb94c11833dd9508ce34a7fc9eb8f6e5ab0c04f65ce2d7ff6f5fd8089fd01eb";
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
