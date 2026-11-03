{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793722126-g0307eb";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "41023cc7f598503c550882735318fb840497403f53700d43b858b2b9db2d9db7";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "58d5f422d6a35474d67b4c84459d7aa20d2e7d71b93081d4255ab2c13697f225";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "dca3f8cdee8c93cd9e11db90203306452c08bcee8b173ce60985af63ccfa155b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "507658106786ac65cd0894b144c58b34c643af5572820ef4131f86cf819b9e45";
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
