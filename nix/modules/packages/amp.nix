{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1782851652-gfd0e56";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "25f76c5f0c1f6eeaff33a0808ec8d1857c08cd443dfddf37c4598351ac95af0c";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "83211555e87f4b6bec62e1d168b235e971e00a6317d35ffd611e05fc460ef510";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "efe08d65e003965de74cea6f948a6f13a9d5b13439087d901ab9150c3a851f03";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "cf75f4551351901e335f1e7cce6e6ed54aa59aff8caa7fe347960a3f74d532d7";
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
