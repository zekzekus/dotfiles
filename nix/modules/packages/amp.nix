{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786896116-gd65cd9";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "3cadce8eabb5d69563bea9a29334800cba8cd12a221c15a6c1787328d4d648bc";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "098bfcb5eab3437cb977992067628fddf5a4c933e0b5785fdca4cf38a90c9ee3";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "03e788cdce98b81e310797f881dfeece689d4de68e81b4d9bae8e2227de96282";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "7cfd3e1fc3874d2fd998216ee1bdf091cf44249128bbdb4960ea636858f88eaa";
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
