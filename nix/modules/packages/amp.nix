{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1794672034-g01d6fa";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "0a8e4858ba97cf3fac9bcc551b67e32139a5de99740febfee70d639bbed650af";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "89fc955845ea45d74d2aca969ffd4f9345343a647318f1647a8c9083520d7eb4";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "d9812083a49f4dd3412caf839e3373161dc67185b0076dbee75971e93c05f64c";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "9052672247e02388ebee0219398fa8b4791280616483da7d90f3f38ee27d8539";
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
