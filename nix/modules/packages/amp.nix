{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1791134020-gd49eb2";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "f526116da0d24c90af9f7457ebe0df6808d77c2f6e0b450e30a510b65791e5d5";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "ade60080a326c3300103673bf57241e2a0fbbe11b9d7b4e6bd3b303f39af6dfd";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "ba1d30c1c2d02898352594ef068e78ce2390f7c13b8327f5dbe54cb6a737e62b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "5b045195fa188f3ac6e1f4ea737863024d236497ba412e4353bc7b605fc1e0b7";
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
