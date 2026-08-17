{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786968161-gdd03ae";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "91aa4d6ac63c8cdf3134e888660d7d00244f99bf4df4e42a04e70ce46d73ecec";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "6c5386cf32c352ac0d8727aa3acc2039d59e4e1d3ef267f07a98063854bb8a42";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "9add0362a1e647d93e4621ba82c501e0fd5c5b86914f11fbe7c9b1c75a570337";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "ca7826ae281eeece2969ad0be585c4a38a90edd1db5db17a7931150784d2346c";
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
