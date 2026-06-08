{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780954218-ga27553";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "2c9ee1e4ba1d1b7ed49c137eaeb3358a4585899ef6288212536bedf2e2fa1468";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "d2a90f5c818d0baa929cf11cac25ea444ead13b4d1e89e5022fd8f006f9cde02";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "b5991468c94a955b3943cced0b75c6c0087609de80b1b341d416f2b2f2f6cd99";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "caeff80a333c2ad40f1bce4d55fb1deec4c12e2794ba77ab2de89b13e344c84e";
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
