{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787829336-g289152";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "b74cb16a85a96ba6ebc14f5458b94ae525c88eef25a5ef71accc682d391b080a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "7662134a13ad5fb5511e6fdbbbb333b3a5d8add84a0a7f0148fc2bcf5842eb97";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "eb44b5a5df1faff6e18507523a71035b9180cae5c82a52883b9903988c65b00a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "feedd501856be4ad0d158e7dc0f34c35a5869826ea4f01a4710742db7642672f";
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
