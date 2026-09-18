{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1789704050-g778045";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "210677db966a0568353c13e62fae3111212d40531ea51a66f726466d09b181ec";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "1814dfb13880af2400bee0fc11807597f59664a1f6d725ab57960a330a009389";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "531c74cfcf3c3970dc6520ff8fabfe42b36d844252ae0a1fe806abdc813ea9a2";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "111acbc52f9f9e1e7310b227b6b9e6235ec35783bf7cfb132f7e34d11c3f4367";
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
