{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789012846-g065e0b";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "e1a3c9e3fb7bd1fab5dd38c5933f4b6b87b273ab947d5b80d29bca87264200d8";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "33a1a6349bd5d43f7f2f41c989213c34d9e19e7ee4c39464ccd452f392d24041";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e5e8a2bbbab0870318ceaae16b328e145efd2b2d536d0987a1bcd1c65c4a5662";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "135b128091fab342e91db12758d05d847413c8684f429f1ef53d3d283430bda2";
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
