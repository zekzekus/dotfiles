{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1788537632-g334da4";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "eea62f3608c58da4b3a2734665549ae83c0cf657382fa3774d1693316335815e";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "ae5b3b4bbf7e199684d259fb7024fab489ebbd95f88b67f094a99069ba085357";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e6710cc6e7eb1aaf51ffd6643ce0d4f3ca50d02bde029874fe9c994306c26797";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "5f7eea3f42cc9311e28ca428f564f2b0e89122d826ad0ed5ae24391ebd1e5865";
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
