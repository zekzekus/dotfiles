{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781191557-g0be3ef";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "fcf080f47292eebb2a728f7836188d625408b7601821f332c1759fc4812de785";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a286d6461dedf9edc574257f8f22a35b5717f9947dc183a3669931b1d58bbe7e";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e987235d522b30b960fa86baf780af06e5e2b89b45e1a2707829f9eac9eb94dd";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "c55e0450e69ba0e1b2d4122f48748ed8b461844fe8f699eb235e936e6f3e47f1";
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
