{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785933103-g9dcb81";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "0e05ff10bffb2f705645f697c45ea3ec00edaef4d33716e3ac4b8d350dccac32";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0aa4746ddb7c543f6337bc0f634d7bef675ff72b18187f714de3e0ff393e4533";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "06884aba58f7fc5ecf56bb3eed58cf3071331189f9503dc60846671ba577722b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "39b6537e6973a028bf6c4594bb9aef187c3bdf220e683ed9cd608fd35daefeec";
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
