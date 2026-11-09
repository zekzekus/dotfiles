{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1794240032-ga42e06";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "514e98aa6ef6142bc45d28140704ac63ad2e72eed19b26ce15d629b8028d95b7";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "cc05516d9c5d8fce870275d070c25cabcdcf798855c23c33b5ae8e45383ecc74";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "34c692936aa80ad3bac4824c093227a5efd2b3e4696367954ed0559015d5014d";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "0820ca00ac743498e11a318763ed57005aa54204b48642be749f4f855e9c16ae";
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
