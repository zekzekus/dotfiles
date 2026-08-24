{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787573048-g90061d";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "f1fd8913e935a3e4f1c8c777284894f024ec9cf31342972b2fcfb30740a05541";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "f9191eb047c393c7a3091eb1adf6d5b8bc07975c21f511bfc07048561bc2c149";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "4576d7ea8fceb431f2c45c1f051959044757a02a9cc7b7fa3b8a12d2225efe10";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "2060c07ce6f18eb4eaeecb314c6e0859564c5108c99243d633c8bfe59049e3d1";
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
