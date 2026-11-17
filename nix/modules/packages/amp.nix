{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1794945632-gf6a800";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "af326e990ff41c8765638bb24fcd94bfa09173ac588a01195f87ad3cbcaaf6df";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "e9deb990603863060476b34b6468155a44746520793ca118328f6c212b873596";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "e5f530d123081ac356c9966cdd158a697a9e8bbcde582852d57bc4075efd5b81";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "7174d01ada35ff3803ca51f904bb1dd9de89ff1e81301717a93c74730c77967d";
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
