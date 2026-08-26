{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787717482-gaaf55c";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "1302985e7a770f2983f2648d2ae0d6565ff303727cce486ba98c8c6976f59059";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "78fe75c568fa13ba7a927a4c68bdf5446a9e8f1c922d712e9c64b97b3930c375";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "bdbd339961f1ea75acf04b7cb774404cbb02d353d8e8aff745bbec843a9c091a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "8256e79d4bde6b4deccee0ae62a477848eb541a60b21f231bbcb281c20adf827";
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
