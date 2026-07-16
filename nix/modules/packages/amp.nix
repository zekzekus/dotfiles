{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1784232995-gb305b4";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "2321b37894bbc8363867db6ba07daa365a43433567479fb8f7d13898c15d17d4";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "473acb16028c2ba3c712470a5bf6adc1d44648a99e52d0587ac94222d487fb9d";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "73180f2336328004f9250a9352243a8a0702d67909ab7ce6a20bcd1c6b413e3c";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "64f22352971de8c814498997490d859f6ef1840edcc08e11f07711c20fa1805a";
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
