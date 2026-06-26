{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1782494818-g890a1a";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "5cca07a4ccb2717dd6b75bcece338dc760b471e94c4e513f6dd7ceabba05d294";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "f5223019cedcc4cb52c28299135f6632b1ff761a9c0666673c4895fc78715884";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "941c8d0622865f71c619294bdd8c5eab053fe858c3110235945bf52976255b9a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "6d879b824b3df5f8574ef174154b567202961b282d381b2541c7836041c31868";
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
