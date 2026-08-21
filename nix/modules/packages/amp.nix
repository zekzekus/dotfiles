{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787299749-g1ad2d8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "ce8183cf376d8984c5f3229d90c8aa67707da4d02bd1aece9aaedf18b0ca5f3b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "080b7f851a5115286d2a2aa6b07dd09a7757591a6467a45a7eb232e1afbd4ec9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "2ec403f92b0bdd852ae09603bfcc58263b8fb974e391c4f9adb5653f84a90cf2";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "88d8d63718dc4bbdb3e47408aac94bd0aea2348275485700155ec6c210c72de3";
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
