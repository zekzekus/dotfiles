{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788367255-g70055c";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "546708441421587796b654bc4342926b6e522b60318521d0c5fd1b2e6ac6434b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "17fa7a07ff82066b02db168b2d90ec4927bc86c7513acc6fe994565dd8a6adf4";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "684fb448dc8026e6bb26f500b2bbe1fce9a2797190468c2920296c1b669fe16b";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "3ab27d49cf59067abef821dd1e2bc6cd7167cf04e7e687a0f7f5f05d3f2ad192";
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
