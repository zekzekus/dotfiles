{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793682830-gad461e";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "7f133b37040c3b6f0f96c22c8ab156e2ae19b8d671d67d23479eb1467fcf1cd3";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "15c112a5976a35f1fbde5d69ddfa8bd26c13d0d017c051f0b5d52682d487ae20";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "01b77de9a67604343e50ff660f69ba87b0ebe3d8f70518462ef00528d4110bc9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "b2cb850f827f5ddf0f5b73520d96ea345362543978b25d01e31cb9dec69abc94";
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
