{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1791633643-g895a91";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "598aaa5f1bd73c1fe8df376d7ca308c8937322bc01f65a19f326a39708399d52";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a4f16e7a3b2c35a50303a3effda90ac81eadd44b3aa1361c84bf4c76021279b0";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "8194083765da3b48394aa05552f8ae0873c98348900b39edf85a506c9fbfc4e9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "bd1c4cf772ade28770a649f5764c801656de218581a497bf727aaa32f80a67ab";
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
