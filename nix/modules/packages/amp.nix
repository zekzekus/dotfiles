{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780656948-g0a52b8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "beb7f3d2cf7b77742b4c8906c529b28e53a9971f9953195af04b3a266320ffcc";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "590cab33f63f7a65a2ea5d3477b8a9501e7fac7a59498a8c98a3cab8628fa852";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "437fbeaaeeb067b248ad8c4b79bf64e03a2c49c5f3c1e3f87fb1db701972dbe9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "8fbae1c343c50067490d0c71b37dd4e12163a9d1e2c382a7335d1a6a62804aec";
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
