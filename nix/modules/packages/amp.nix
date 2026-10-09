{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1791532981-gacd0a1";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "3cc8b956353c208597b840f7b960bcf96e98880e270b308bcaaf48a937fef6bb";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "9662fce9d838a64d647540d3f34a3e5f7db3874547e13830be4f746ba151256f";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "fe68080d9901818b3b9a6feb0ebe14b8392a078ebc6005992ebba91aac461bb7";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "86cab03f77d9ce124af275a549c8ebeca32518c273172f697336cbfd6d1e904b";
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
