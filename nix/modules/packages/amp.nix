{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1781941194-g2385c0";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "b8d48f36c13772f3a48071d6c1ac96817be5e82fc7e46c647d218bdd3ef01ca9";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "4aaf6e3d940869a93ca2e24e749ff29a78324ff5c2a676e163534140a57fdeb9";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e48d0513d63f837382e235e9806b5486566695382d9adb71ca746424414065f6";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "67cbec4475a287d526b55735f7ed484b23f10f2200d3fceb4d843125680c489d";
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
