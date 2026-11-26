{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1795680045-g9e093e";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "509842ae371c45c9beb1c7b51c484028d258160cccb69ec1bb7b42740cf09706";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "619a8d5a6ea981d7b59a2f1029669ad48bc70958631aeafbb240d99072d424a9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "222270602ea352bbe5a44d40cf63ad40c4313fd41793160aa18529a98cc0f025";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "900bc10e150a980428c6590a314a6913bbb7b65aec64d390a18b9b9ea1ed6171";
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
