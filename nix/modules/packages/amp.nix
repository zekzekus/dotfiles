{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1783282957-g66f800";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "94920f14fd22ca5624c42e61a3fde18ed0ec4661a547548c4149d597f6fa06a7";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "efdb5367b4cd56d060ec4376bc41f305c48c41617edeae79e47aa301337887ec";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "20630c48324fad06731a2f1295b4f9a5cd3bc7b62123a2afafb74ad50a2d79f6";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "1423397b25cad8393624ad771d65ca02af13e27a96e504317dc100d4b0c76638";
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
