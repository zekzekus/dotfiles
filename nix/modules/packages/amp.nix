{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788883237-g0b98e3";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "266d75106b8fcb71f96d495d53d958ecea5ef851e65dcd4929abe2f591c74f50";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "4d5432a316ec6f1b0e81b9c0a82bc6a0f7e14012e2b09027a7811a553915a2b2";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "a8544b1235060f89e2cedd1e5ede91f1762a3c66b32ba81f7ee80f13a7f032c1";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "6abbd79f48fa68216fe500ba6e8caf71eb22ce13504f68594e0c836b837d9403";
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
