{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1792425645-g3c5d47";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "c4ce48772263a77faac4621db481e62df2d66abf62abc729b06977f2c39a58a6";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "98710daf6633a1bc0f9b0e23c060025829e6140ccddd08872adda7ecef6c1a0b";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "c5833f65afffddb18b2e6bab5bd1d722d052fd71b2b100ee790bd583768df108";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "84e71b37dd017a53e17cb2b53aa1f0ae76dd0a0ad2c66759698995b3a45a05ff";
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
