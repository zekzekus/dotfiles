{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785701947-g840756";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "3a1ecc51d46fddfbdf12c7243aeb46fac208dd4a6ce0fec8ddaf5420efc4b87b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "f0f48ec775f7be76cc5b05fe0cb4e03d208807cb2ec66fff7973a0d8b506ad56";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "2e89a7885dd4ce194ee5316c96393e8764d31d00b8020796b6c38e5cf65a99b9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "04388027d19ea3299a87e4a52203118971c1445b987220f13c38dd7d9ef3cbaf";
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
