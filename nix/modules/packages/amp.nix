{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1783629102-g8185a2";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "0326b8c7f8301a7be1805382048dc6d6d4eb94c300c04cf4d412620f5f72fa8b";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a75ae0c33c8bdf1dfdd6423198c69186adf34339bca6da185d101fc4a9e7d985";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "a35c9c0fed646587429df8da06737b540f37487528c3fd7f698384bfb82ce678";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "36cf29db5fe44cf79f722e4e494bb140dcdea35c58cb8a29913df8d42610df09";
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
