{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1790884861-gc8feff";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "c82bc00c79a106ed3ec3a3ca27797c5794b05f1aa05e6c5ad68c04064c383ef2";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "b9476aed953ee820cd502fd316e8a273200f4196a2a05cbe4b50d35b040e5086";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "190ee3effe20ff0f10f593ca09dd77f438f946731789ac14c81ca89581ec8f3d";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "961fb852d8e05bb3dfefcbcdc1a062f2b788e06a74f061f47181ce3f8bb33904";
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
