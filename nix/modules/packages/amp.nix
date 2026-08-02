{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785687550-g686ee1";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "39c1b2b4e8821a4a94f95c159e37f5bf295a7655b47ef4d975520f629a1f01d7";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "133c2fe1f800057b6cf8dfa47ba4dfb72c70c83728ae3cb7b6da43cd9e4caf93";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "f78bac6f6b5c0db1200abf595e1df68a72b6bd4a35319f2dc6fb2623534107da";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "c18a76a65bfc6770d41ff19a35841cfcc73ec8d42835d40f5dc90a6bd29938a6";
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
