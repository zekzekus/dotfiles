{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1780837959-gadecaa8";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "2a98ea76196750c53689d4b2457ff8927c14c038016bd40243468c94e8047872";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "8d174dbc373e31d885ddab68597f18f4cab17e05770828c992f5eaf222f3f15c";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "31e315616b6114afd5d2cbf1ecc95cb8c0f522ffd141b268e93a5a1f92220b83";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "bab61d40ede78aa2a8e8ad55873d780233e18b04524c23b26396ba56795e533f";
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
