{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781870657-ga082e1";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "c5ad7c3ce564b11a9393743b244b7040a3c738a688c4776d0874201cb6df9b70";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "37e105e031af5770947eff9c22e3a2f40611bca007bf2a4fec2dfa45cd577f59";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "802943b4a63b8ad3e9896836d74c4f29ede5ad9535c4f9f30f3fec858049064d";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "aa84d55e07c27991f986c0aa6e5f85ddee0c2dafc9895c141bca5eac85c162ab";
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
