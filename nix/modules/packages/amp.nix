{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1784838101-ga3144b";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "2c821c39f8b12fc77bac419f606c4cfc7919d2b085b67fa701d4a435f63604ef";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "fc9058087ce78eadae019a66c41197e29ea0298dde06e02e06748b71c4dbf092";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "2233aaf9ffa091aca51e803d85134717d1659ae522c25ff2da8748da9c3c6407";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "52f7d780023b368988f9cfa8a82c5388a29feba7173de9fb92083a1128fc4fc7";
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
