{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1782223980-gdee513";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "4dabc7698d556e844a6697260c6b3e131876c417306698492b2ecb0edc5fa4c3";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "de1420d244926ade6922fd75babd423d572a6f08e4d0eb02f08b2351f4f79b25";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "2a513e457a238cd0bece05f9a1e9294cc234d6e70700249aeaa78c4c0a1deb9a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "d45a2bb5bf01c4d9984b0fd2fbc9612ccdf500838ebd87280b3cce9671bcfc71";
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
