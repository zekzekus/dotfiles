{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779282840-g903e85";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "4cbee5479d096dfc4571c5ddf1588290273a139a5b0ecce30fac5eaaa4b0f46a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "eacde05e938568c613d89cd15fa714111a104eff7a02a8471668b0e2d7df7900";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "a6caeb9c5e3e66c561546850bec95077a1056926e4a2e9ff13db8f6e45551f82";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "4c7e5ae06619cf21bf63aa54f8a9563812076cacbd77efda33ce0a4b260d9927";
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
