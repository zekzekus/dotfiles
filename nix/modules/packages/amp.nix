{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787674203-g8784ca";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "dfdc3fc6e773aed74746d5587a9e4d5a0b2639938bae247781da8e9092674b46";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "9fda55d9ed3fce9353063b1818677a1f5220a69e9775c3329209b8f867f88fe2";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "23f813fc95416a0f4e5ecf321fcc0b8bbc375fb98bc6f2dd0362eb8ae97fe099";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "aca893283a314dac95ad19534bfe09e673adc6661458693a39fa51bb59fa1a17";
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
