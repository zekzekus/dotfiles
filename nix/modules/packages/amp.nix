{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779019981-g8f743a";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "8e038e79e78832b02d3f8fa60b300cd2c61259d12cf7a026deb99f00d15adb3a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0b19da24795277575eb14eee4d241cd957e75fd36412025b8dd8942de0e863c9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "cb350ad237fbd8e39516ec2e4cb635830187328096025ab2a53b01460219ade9";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "c51b6859eda7e208c63137ef3459a3156f38ccf00eea04c7cf564144bd3dc20e";
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
