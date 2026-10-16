{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1792185362-ga97f29";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "72f8eeb7c723be0bfe4cca5eb2bd9c133139a97c053e49b4ea253b33f4952ca9";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "5257c2a6c716034a790993892ba5350f782548830f751680d6dfa26c5c962786";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "459d2cea894eb64fcc0b3258e91a1ae28bfb26f7d938cf46fc8f4bbc332640ec";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "bb05fe12521ede096b47cdb88534cea616b1e8ecacb7073bdf8bafca8b8a63dc";
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
