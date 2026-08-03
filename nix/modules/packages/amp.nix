{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785775571-g90a48e";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "27ee657665acbc9f60f5793bd96de583effd503160bebce1319ab3add5587557";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "2386e8a4ff2605cf4a08cbf59af6e3c7e1fff57dd7ea02040c9581c7fa6cd39b";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "886dca1adf7b3c9d4a563e556f5c4ce6e0bdc3c9e628c152e9ab9bf64dbf8ae8";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "9c5e512f368c089b840b38e952a2f1ff98f457b1ad6ce83dbbb0e51aeb7a2752";
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
