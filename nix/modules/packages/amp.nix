{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781291340-g764849";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "cce96c519b713588d6ab92bb0149cf24be12b447fa1566f3ee0dfe2462738081";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "d19f8414960bd150144c409c27eb1c862e8bf68f965b97a8cf3c086144ca5b15";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "911f6b2e65f6b17be2638c44ac0483c5903f5d0c0134490e5204efb5ced92ab5";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "fe67d0306ddefa62a19fc9ec3c840fe6ecbae86b6659d8ea1d32660c15b32670";
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
