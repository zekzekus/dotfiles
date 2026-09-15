{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789461065-g3013e9";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "e8485fdee3edcab127b6224d26b86b655d113fafa53236c8422e50c55d4c1281";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a94eaf111da236208bc3c5b89a39e46c63b87c1646ae0657682056714e923b11";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "7c1a6d120a518017915856456b7b2c73e033f4d70952b1e7c7e12fdbb681332d";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "f04a24731bbe562a34b3bb1b7ad807ab62b87860989598588cff033c965331ea";
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
