{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779007153-g35ddd7";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "2cbf5fa02cc04947e35f68a1605c53060f1b7ab8a3890fd68753ba6a3c50524b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "c6cdbac9a2bd9c51b0d89b11e7369f7c63771ad9fe21d9a156fd0671ed96df99";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "ebf9163492d113ac15e4e1be797656f5f8b0931a1288977dc6c93495f4fc80a1";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "321788cf90ae867f0c9b4b3569cafa1cb211190d21340b996de55f1c2caf1e00";
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
