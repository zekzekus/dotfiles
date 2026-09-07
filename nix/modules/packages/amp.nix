{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788796834-g600a1b";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "0f9f9ab02f706fd4949f2f818f06b9b22cf099b4db175c099c32643c6083f33f";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "660f456959c74bb55d1aedc9f71af33914a40ea6fe02ede30a1fb96cc3339677";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "97707af479c44dc8b19f341271b258b04024fa69a578b9f45eb98b64401d1d84";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "fa69c9ff22118e6e94b879d38e014970b070169db8b7d05853cd91ccc380ad78";
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
