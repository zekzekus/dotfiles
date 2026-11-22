{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1795363233-gbb6f68";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "ea144f08f3e1f2a9b65493fd2b663f3f8d33ba960dd4047aea071ccefd5ca51f";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "fc25e0ccd13f2b5097f1b655f6912e33e3141b83811479171024f0f08fa1b3fb";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "11c0f530b429a94bfdf81c1b4c7c67f9451fe7188a1de2416d663f48a2af4870";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "1745f552793a07752c1433acf37acdd6fdc974fca06595ff3af6ee863042bce0";
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
