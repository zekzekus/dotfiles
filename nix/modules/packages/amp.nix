{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1787961677-g372167";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "1840388f67d827303f924400301fe90c79c9cc765ff973bfcd62f16dfdcff6b6";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "1c1fa476d27c3328eb1979f11a1296f5af7b255a4d7913896cd90fca3b9a1c1f";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "652e380c2261f3c9d05b07ab773b7b86df5ce09320036830777508acb4d26301";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "eb68a122c357f52b0edc37960ad39533006ead68cfbac1f73d50d1bb9d17e24a";
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
