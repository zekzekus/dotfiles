{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1784305484-g8dbc9a";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "bd751ce55ce0577a815a48e18acb2b2742b07f46e95b092b7ba0590d542cd70c";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "a6e4747296f6250f43c3202f62b48b8f4a933242c656676d8e1d647b3a35141b";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "ac55ca4af49ffc6a15a6bbf5a978d7a8108f0e248b440694699a92c8e7ac127f";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "37d501552fda0da563250596a4babe86b06ecaf5e57e1563d2a93f934fc31171";
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
