{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787400091-g3923ce";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "b1db5a2931f1748cf38f3778d7b4ce4273c3b3bad91e884636e90288ed52bd08";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "8879a93a57789288bb83ea0974833ba8721fb7662b4fabb57275e64c97b0b16a";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "92d57add63eaf54c7bb9ab2af8ca0b438b40e50665894f1cded8b4d650f4003a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "6788f17adb04f10ae4cf794e71d591e8cdaa84570738f0eb6b4ce132743c023b";
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
