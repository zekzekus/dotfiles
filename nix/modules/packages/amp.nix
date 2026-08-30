{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788091238-g043a16";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "208addae81beca481b2d7e68985a2599b2405cee230bc8ad854fa71a251eb37e";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0f46582a2a42c6791677cce22e0f28127911b94c6ff06d785ff115b87b9a7662";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "fcd7031ba8774be00fd104dacb75fa899bf85cb4a7dbf6ff92ebe787f221c588";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "deeb261151a7f08416e1a09b71cba7877daec9d2ec36dfd40a6751235b9ee966";
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
