{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1783845703-gd84c78";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "d92ff72e9d3475d9115aeb2ee425fe5ef8b3be27e070b73a0e23b173451e7aab";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "c8640567981881584d2d49eca5a0ea475ed67f73d16ada4eb7e573e75d363021";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "810355a30d0dd35a6c552c563a01e1eb3bdff0f098838ed0f5825a17429211d3";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "324988465e19797043f631fe45f6731813f2c2c089a91214657089a48155c3a6";
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
