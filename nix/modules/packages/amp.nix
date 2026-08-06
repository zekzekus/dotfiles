{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786019606-geb05a8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "1932d156eaafb5329a0e1bfe7d0fc154af288cbafc908b3015a58b022008bcc9";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a4f8d4b904fa38181f6bcafe06422ecd6cf518f4224f3907a462ef3588c89e35";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "f3ef517b5d8a5a3c97a26bc5fcee0683b8976d61820aa3c87994e8f81b5489fa";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "abdf867dd13f11350b63176c10a651d0e632b9c27930fdd98b10070057be795a";
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
