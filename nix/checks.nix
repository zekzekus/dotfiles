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
        root = ./..;
        fileset = pkgs.lib.fileset.fileFilter (file: file.hasExt "nix") ./..;
      };
      doctorSource = pkgs.lib.fileset.toSource {
        root = ./..;
        fileset = pkgs.lib.fileset.unions [
          ../flake.nix
          ./lib.nix
          ./doctor.nix
          ../Makefile
          ../scripts/doctor
          ../scripts/tests/test_doctor.py
        ];
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
      doctor =
        pkgs.runCommand "check-doctor" {
          nativeBuildInputs = with pkgs; [bash python3 nix sops age git gnumake shellcheck];
        } ''
          export HOME=$TMPDIR/home
          mkdir -p "$HOME"
          cd ${doctorSource}
          shellcheck scripts/doctor
          python3 -B -m unittest discover -s scripts/tests -v
          touch $out
        '';
    }
  );

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  devShells = forAllSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        alejandra
        deadnix
        statix
        nixd
        nil
        # entroly (https://github.com/juyterman1000/entroly):
        # `uv tool install entroly` then `entroly go`
        python3
        shellcheck
        sops
        age
        uv
      ];

      shellHook = ''
        export UV_PYTHON=${pkgs.python3}/bin/python3
        export PATH="$HOME/.local/bin:$PATH"
      '';
    };
  });
}
