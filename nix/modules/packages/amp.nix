{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1795521647-gb04512";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "8bdf1530b58f0355b7d0768487801f8fd5da9c56c89ca200c99d1508ed844d30";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "372cf9dfb42553317b76707e0b0e3e146c071cef2c41d2e67264de376caab1ad";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "b77b392d7a7bdc97c4615928aebbfedbf49af7ac827daa909e1c7eabcdea0b99";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "eb04756463cc392c06be899d728970c5e336539f9f6f48d8d249b6780380cc85";
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
