{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787117828-g1c5807";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "e564f3eea184aea89ebf63a3481c487c299ddb65d6efcd48de221f6942fa1750";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a2a9d9b364ad9fc838c8b0d6ecfb8d206869c89d4f35b2d2f1b68c42f06805c9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "c6f031708160688088d9885e90b63ad3fba1190dba4f283750e617e805616d6a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "de9833cbe70af6878b32351fe58117d4609d8d1443e3fa1d804d8af9aeecf31a";
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
