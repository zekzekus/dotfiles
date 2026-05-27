{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779922972-g832d94";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "f5ee8233bc49890e732d2d3f7b3f227854004c272d9690bb027240e59a885894";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "ea76ff2c9c7260d8cb25af51c22b55606ebc426328ce64a944002e72c2d66790";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "8ca82c3e0dda2c844241fab1519795451384b6f3ea5c3075a373cdf748d1bd70";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "a67d7667466185aa35425af3466ed550f2bdc52ef3bfd95bec1478f58e687e2b";
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
