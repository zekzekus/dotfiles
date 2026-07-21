{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1784627333-g3eadaf";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "96ca80e0547d62a50a4eadf4766552400e3c9b187b771d2c3e147e848b8491c1";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "ff45ef5011274a2e8355f2054b0ca5431f35ae49086f7dea8b8fc45f17e4656c";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "17247dbe70cd5635736dd1fb62a3862b2869e43a3253579cde010cf7afb27f13";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "cd05352462ea73874c4a535e3931cc176d74d633a2caf795441c2c13d8ca9168";
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
