{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780750825-g9a754d";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "dfb0d16d7596a18e466cccf9b2615ec1f08de74ca2546d0594326e732e9638b9";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a527e542fffe1fccc7c244266e9d3fc6b895c2132f8e104aa441f7013c6b21d9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "728a62ad8dead5e779b7c109067437fc05563986c0a48f9a7cfbd8f0c3138518";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "2010044c5ee2be70179d6cb2fda5c1308f00691894c0e1e5bbcf02c0fa10b191";
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
