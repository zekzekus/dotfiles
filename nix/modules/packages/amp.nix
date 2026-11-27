{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1795780844-g2b802b";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "9089b1a1dfdd21b0b94cb26041d8da3bae43fbfe491dcaa88f7c89244485b9c4";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "95fec3c4fbe5a4aaed4b19239d48b7b64b591ad0c031d0645ed3f028c8ccfa8d";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "14798f697d3c3508f93376671c555434ae8534e0030ea7a19763217c337c7f1b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "1329992043a58e6687c41159c979c8f6b832f66a48004298d67e222a1828f1d1";
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
