{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1783428245-g418259";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "f38a9244fd54fcdad002972bd2bf94bc6da2f38f364ee5efd127fe7fe15b314d";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "ac2ec42d1fdec29aa2cf466c238ada8902929601a842c332fe33a34b5867989c";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "8fdea6eb2cdcec9ea08bc3aaa26761a300eaf2e939f8fe010936eddeaf826e3d";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "4c64912f163f2afe2bad78c505b96f6cca425cd7cfb72611833f12eab0cd7e54";
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
