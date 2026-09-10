{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789060657-gbbbea4";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "54f93b82df7ff357c3ca0331294c88f696c226ebdd78bae60b7a5ea353e9bd2a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "45e1083dfa9cd06333fcecb4ba658ae42f276788f97bfacaadd8df242dff170d";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "51935169b1248b36325c9e50c0478616f6a4377ea57377589536bb30a6cfa18e";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "fba7fdd05754d8c72092fae27d69914030c5b74133b73e200724ede5628e4650";
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
