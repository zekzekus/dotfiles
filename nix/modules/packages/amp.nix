{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781088312-gec99cb";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "4786cd65b2e534907d085f6fa9124a1dd732946d0d0b35dad43db9bbcff37580";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "f692e15bef39ddca2758da76c1276dd20b0bb4a612e75c7306ef494bf7c4e3c8";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e23da4604d35a66c9dff2c9b83af2d2e11adaf061f3453a886b833937375ca09";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "46a07a1ba5edfe7156bdeddb6b76ef3291de62fa0fb1388ae83061a2f064baa4";
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
