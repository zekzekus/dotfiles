{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779109569-gabaf79";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "ca99aac1754488dda2fc14a6170034aa5ca25571591f46111e8c65c32b64fb85";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "deaaaef5f6e7f7a469a23bbc232d085d69952651a0cd72b9aa00463b70560efb";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "89744b2af4ee1566fd71503f9aea31ae62299f5ce9143ad28495bf5900639c67";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "7e25e3b55d6b727a227c2c0dd73446ecf4231ddb7b4d3ed40aae8a6eb5178024";
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
