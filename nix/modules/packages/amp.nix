{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1783110194-gbf08da";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "225a088713b4df24611ffa032982c26f0c875569b9e4c3f70f0ad386102d8ebf";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a44689aa1294f4407d4f5c8fae433426d85e3e600500961600a798acfb2d569e";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "ce572dc328dc95e5f3612c09cae327accbd05e04cab151e4ac99211a73f49423";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "1505dd3bba4381534c3fa9f1679ce83d3cf58832db589ac919eb1c95689a822e";
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
