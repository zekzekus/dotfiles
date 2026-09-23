{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1790171806-gfe69b3";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "6cfb186ecf5ca651e15ffbfd06ab22ef2c535c5b6a6dbbbcd13e686ca2509318";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "8c407ce47cf53ef19e0ea990d7a6fcc2715b30e6bf348f0ba7f01738ef2a4919";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "33b8ca8f3920edd2128a6c16609de10c9d6e74796fec780696a7dcb9fa5e95eb";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "b8c7344514db5a1e767a12ae83531ebb1952a2ed903f457f16f801fad6fc59fb";
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
