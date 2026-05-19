{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779172681-g60b2a5";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "1b040f0bfca350b6321944108e30163866afc59c3f99551c11212205c340b9f6";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "2aa5d57f1a9b733c6590ae5efd107b6f34be8f9dfb460ed482134ce92161d0eb";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "48d79c8216563342cca6cd107528a02fcf246855aa17fea2be9e2a23b57a3834";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "1bce0ca68ff4274594c58659618d860c9a8c5fa140fc7a71884ef88c034f6ddc";
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
