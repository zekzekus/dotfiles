{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1792339235-g285db8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "bf508d51617a71afdd6484d5d17c62e006ebcf0bf6ff73eaadf622298a32d755";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "eb95a484ca3de7733907fa0c50fc71acc3e37dc8e21a701345014a166559d98b";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "889ca0445b84a3a2216374244418b422cc2ea81c588b5e10905b6bc76618600e";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "5d586a9051894008e20fe61567c94d5379c3e3671780372e212eb370a7787a13";
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
