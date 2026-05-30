{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780161554-g4269dd";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "0be5bb3c4aab03ddee938c03184d259a0b547d2c419c0586e385559809cef953";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "797e0d7444661967eb926e0e0510138e1da98f1793c9cd25eb9ed076002dc738";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "c56dd5dc2e230ded8dd87b11d0f5b16ff30a1f119171f9415f4ae38a7824b126";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "8e1d01d6672c314b506dc9f5c3052f6ff37a3411b3db801964b8067269260c47";
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
