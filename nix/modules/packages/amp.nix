{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781370323-g977781";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "97bae60370d2b69b48d043a36d313c1858a7bbc55d417a98f35d42819b02803e";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "b4f1738bd55a41bbae7a6a19e49ac9d5c38b7fa229d2b07c70e475af7d850b37";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "ea06ca993f1b3d57bf43367e73ac43b384672caa90255985dc5bbf5e75b83f36";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "77d8660c619357701f7ec1dc58346bebc9156efad905f283615000bab38abe45";
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
