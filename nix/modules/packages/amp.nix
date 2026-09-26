{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1790395249-g17ed45";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "80cf85f9acc0f95bbce7b8d9d0cce248944c8b3e9b9694e0ee573e0a7129e1f1";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "f7f044a877790bcbc84f3fbe879c0a5537e70526a39c957f1ddd8dcdb3ba1083";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e18d183932e63bc12d3938c2d8474d9476a2f5a1a16b29f3ff8ad7d0086a2407";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "f43752540208d4f8b944884d209318731cee609801665d9a31503bcdba1ea292";
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
