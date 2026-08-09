{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1786291588-g1c260a";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "3626e2eee8011e3108560aa4e56fda1614eecc977d8df9dd14ddd356bacc90e2";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "97622d83fdf81b867e20b9cfc243f62a8b4fb54b13db62de86045d16da731b93";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "9e82b5d625981b55ff8d04a427b2d598ead5e2dd1d531ef6f44f5de3e5d4cd50";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "60a81e768b4b3de404e4dd897841d382a059afe150b4110da24015d608492505";
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
