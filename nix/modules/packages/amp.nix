{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1785660266-g6a1789";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "4ebf708c9d79956250f97c2417a0f691bb8b640dd997e5c9366849973602eb09";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "10965a4d17b96701977d2482134647e39eab256e8dde211e8c72df018e83b3e6";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "72bbb07ab93f143dd3d87f91685884a0fa7aa2e7f2b4502ee4ed2871eaa9c995";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "a63f9d7433094a739b8d230f154974e6a232a799d2c5154a2b6fb2c71315f90b";
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
