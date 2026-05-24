{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779612413-g6d0650";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "9614eebf6c12afdcdef3728aa7c68a11541312a292a7a33d193da335466f8352";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "f1607d2060c8dc28af1da134a5bd8745c62da29ffb0a85196bb49c88d6f5a0f8";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "54f0178e038583fb200a85c6eb44aa9f2b4b45282cb8a0d5efda7bb6e8d51516";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "df58ee2b3e87e33de3df08627e17577161f4d46155cc8d8f3f4e99dfa704adb5";
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
