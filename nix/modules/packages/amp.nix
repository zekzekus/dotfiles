{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1794139239-ga22467";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "190ea772c93478b85db7076e1619bf5cd695ff4112650f4ea20223c5efcd0ada";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "dd660f6354c6fe9e152bb47c0a33d7c5f7d59a78c4fcb2ac240cc93199ca1655";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "013acd095e4becc99897a3414f4b5387cbf9c7ad9275b7065c3a36c9193ab7f4";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "145c9fb37a217762aab71af91acb4c48373bc9d42f505a875e7cd4db1cb2752c";
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
