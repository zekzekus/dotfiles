{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1782372662-g679db8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "97c1a6602074fce3b27871165d506e8071702e617e13a9d0f009ebb0832eba98";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "d8189e2b290858203163210988a29aa28390e1bdf9ff6679dd63b74032461c85";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "be6febcf487391188b9223e4795050948c5531e0dc8a96744efec2fbcb329c74";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "bfcadfcd0cce0d5db35e496c194c12d4fb83e6440b75ac540880f986dbff2c57";
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
