{
  nixpkgs,
  supportedSystems,
}: let
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
in {
  checks = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nixFiles = pkgs.lib.fileset.toSource {
        root = ./.;
        fileset = pkgs.lib.fileset.fileFilter (file: file.hasExt "nix") ./.;
      };
    in {
      formatting = pkgs.runCommand "check-formatting" {buildInputs = [pkgs.alejandra];} ''
        alejandra --check ${nixFiles}
        touch $out
      '';
      deadnix = pkgs.runCommand "check-deadnix" {buildInputs = [pkgs.deadnix];} ''
        deadnix --fail ${nixFiles}
        touch $out
      '';
      statix = pkgs.runCommand "check-statix" {buildInputs = [pkgs.statix];} ''
        statix check ${nixFiles} --config ${./.statix.toml}
        touch $out
      '';
    }
  );

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
}
