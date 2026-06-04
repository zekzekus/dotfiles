{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780605512-ga5182d";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "78351466ba2ce360008b595b85d789bf3cf4d24be69e10d2d59d38cb91d94e40";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0bad8edb47b6a4e140928e8452cb79fe21a2ffb8d72b069e363c1c9d1ed2d8e4";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "4c7abdd24d686782113cf0f9f651a68453a5fd2ff6892991d6ca78120e82e75e";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "e95444ee1f52f669051a43421dedae2d254cf2181b6f37e023157f4b08ea3fc9";
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
