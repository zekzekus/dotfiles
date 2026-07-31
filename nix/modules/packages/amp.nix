{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785515475-g65101d";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "e523eecffa8a8bfed01b18368f12a171c5751a622d39ac9b5acad0a88c6016b5";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "95bbe9230e8dca316c16636c4fe5e9e4e563513fecceef2b79c23a24689ba521";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "80489e44bfc00c95d2b92d266ddf87b46a1e4ccb5c944359d07410d43006f66f";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "cbfa7c570bfae51894d58f33d90e549cda384b9bd4d36c8d0e49a6e9a3e32e35";
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
