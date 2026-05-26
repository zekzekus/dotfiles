{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779819200-g185332";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "6c2414dc76da750c11251d3510f36c202dc003a43b5eb8c4ac7d60c01dc98c9a";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "162f5eb58b8ca73aa2697340481905b973424fca0e7a3aa47b440a144df52548";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "a748cbcc9d4c937c061aae2f0ff9f071745a1ef0a476b7f2d92af3a5acb57119";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "16233d669af5c497bc9c995c9277095723c2739a3cd9d715f221f993134c79fd";
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
