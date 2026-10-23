{
  stdenv,
  fetchurl,
}: let
  version = "0.0.1792730408-g23e163";

  # Per-system source: (platform, sha256). Pattern is parsed by scripts/update-amp.
  sources = {
    x86_64-linux = {
      platform = "linux-x64";
      sha256 = "fe596c18b8cecf2798640f9920aa15028ad89e8d3c3764da7eac1d5857b6f274";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "9d81a3794165e77616ebad2d8698854174959ad4b112325c2114dcf25870b3d3";
    };
    x86_64-darwin = {
      platform = "darwin-x64";
      sha256 = "cd4e7cd28adda91736b91d62219088cff41bbd80b24f72298ce17514d128a47a";
    };
    aarch64-darwin = {
      platform = "darwin-arm64";
      sha256 = "b1bf3915b8e83abce243c8efb878e69027268f1dbe8ceb295bb7e4880061263e";
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
