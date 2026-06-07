{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780818304-g58b217";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "831b8884e82ab5c0e9366869d143d08266829337f1d2c9fa8753a5b3cc9eb19a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "e71a7d50f79e7e0413defff76ff3673792755ec277bdfb756a7bd6b593f003a0";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "f12e0ee5262adb5bad05948c6ed9852744dab36b638afe4c18832e87cbfa2681";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "6ad2f07768b3c9e473b89ad230d4264eed3dcec367d3ff56e7b8fbbf8be08310";
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
