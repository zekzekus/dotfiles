{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780378195-ge506a8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "412d13760f276d0b150b2de784acad71adbb41e50b941591e1d1e39ae4e1b8a4";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "fc9ca0a758fd59814541e314e1da9bb440df4411d7e91f7f47f6d21256f45441";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "0c2d1e9f25d9c3f57482b9dba010b40f18c87c67b5df4dfe06659629f4d3875a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "78d76886ac8cb8d74840058204f941745bc5edd8bcccbb80c740fb34a01ead1b";
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
