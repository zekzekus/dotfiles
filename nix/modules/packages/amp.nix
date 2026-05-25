{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779700393-g4ef406";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "f69de21f6d9e58a981d3d1db9e12dcd7525e93edfccb3c158bec587f4be90f89";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "222950fb984eac485d73a4a348b81ab585bb11f8a5469759ffaef801c52e21e5";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "18595836888138e890339d02089a616b3b0b79d016a46857ab8c5837bb19c91f";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "226cc60e8fe8f45369d398b357c5a3ab8bd3bac1fab0d5d68af64136a5b99e2e";
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
