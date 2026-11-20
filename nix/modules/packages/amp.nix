{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1795165186-g8afd64";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "832d1d59ce2bf4cd6d88f20ac2609599163fc2de4c867799774db96421f8f03b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "46b9a4814f3e2809ca321bd55fdc2d3958719ba97b0fa6fd6f89f3e7fe960fdb";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "5f1b6e1ad333b8b70393836ae07df79a7e0e6f9e5fbe8db41d1f0c9f9e339fa4";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "15e2cdcb7b75fbcaa3cd2a62d03b595b1b039d5e84a43018a886c76a2cb891ed";
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
