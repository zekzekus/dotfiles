{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780909758-g2d38be";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "1b7488d8aa621ff09ad24bad5ee8331300c71516d089daecaa5d8be67104d6a6";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "c86848635dd259935981098f2e912eb5ecb807d0d3f241e027c9c59e671b8195";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "ca7ab009753a33777e0deb18d7b4540241dcfdbc82e010c73b7bbe1a49d53227";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "4c656774a9941217184192510c7c4408f7d7112e394c32b478197229dec08f6f";
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
