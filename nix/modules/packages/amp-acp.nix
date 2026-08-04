{pkgs}: let
  pname = "amp-acp";
  version = "0.9.0";

  amp = pkgs.callPackage ./amp.nix {};

  src = pkgs.fetchurl {
    url = "https://github.com/tao12345666333/amp-acp/releases/download/v${version}/amp-acp-linux-x86_64.tar.gz";
    hash = "sha256-r6pQoVLrhqj/IeNU3tY/4tIbcwhZaS46YLLEye8j3zE=";
  };
in
  pkgs.stdenvNoCC.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [pkgs.makeWrapper];
    dontUnpack = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      tar -xzf $src
      install -Dm755 amp-acp $out/libexec/amp-acp
      makeWrapper $out/libexec/amp-acp $out/bin/amp-acp \
        --set AMP_CLI_PATH ${amp}/bin/amp
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Agent Client Protocol adapter for Amp";
      homepage = "https://github.com/tao12345666333/amp-acp";
      license = licenses.asl20;
      platforms = ["x86_64-linux"];
      mainProgram = "amp-acp";
    };
  }
