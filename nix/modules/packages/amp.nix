{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1779345702-g49e69d";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "3a18b3cd8e5e144b9e0946dbf9b9754f356454599de3417131ec2b67bad5a8d6";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "0d4ee14359fa15cc0fa2da76161b3f04a7c1a2e3555fd522e5dba7e6c5866172";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "a811e9e0e6d36155ac3181f86ef6851c088f4cf1339796b82c2d29766baf6422";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "008b85662c9b8bffcc77222f4e89a38c954bc1af93e4b0dc103bf0ec3c3a0936";
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
