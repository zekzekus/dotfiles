{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1793217669-gb7b7f6";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "52fc1dcce09f4cd08d24ef64e6512c512444765ac422716f6ca333bd3e2a3d3b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "5aee0eb1e7b7238c0649183e1909f9651b7580478086ccca8568f6dbe4a3d32c";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "a4f136a103fb89cd908b1c599e49248bb8f4d60dc2996499175785ab182e33df";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "9ac1809d4b5fe21093c0562c9d4be5a82cd8a7c67ab69dbd3db9e91ab51d5675";
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
