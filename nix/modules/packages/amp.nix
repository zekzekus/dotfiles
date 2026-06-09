{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781034998-g7dd2da";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "017db1e7a82cc69dc5ad3602d38141ed79d5f697295d08f5ff24396690ad9691";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "89c0f82545d1f581032aa2896ebbb3db556acda4f2fac7a3fbdb2df0edf0d237";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "efa968456bb70c1e89753a12a2a7f4f2edd334dd0fad6ab9f8f8e729c978d5f6";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "7ffb2120a67f682c40ba2b3066df59edea899c6182208fe754d3cded3b527605";
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
