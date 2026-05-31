{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780221487-g6b52f9";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "6944311b9f7dc61b0a46fed3ebdfbf288c409e39b257e95aa98b4525b1ef3cec";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "3c2247fba4e450cc645436bcf23830d739fbef0101a65a3204de126719aa0c22";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "800c319d7c4743f8bcce6b01c2e5200abb5d54434edfb6098af78fadd8f078c4";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "0d4997e6f25a87d2e6b096a1a4bfca7b8cb45061388054351de0c2eaca9270e0";
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
