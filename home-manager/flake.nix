{
  description = "Flake based multi-platform-host setup of zekus";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    determinate,
    nix-darwin,
    nix-homebrew,
    stylix,
    hyprland,
    hyprland-plugins,
    noctalia,
    ...
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default
    ];

    extraHomeModules = [
      stylix.homeModules.stylix
      hyprland.homeManagerModules.default
      noctalia.homeModules.default
    ];

    lib = import ./lib.nix {
      inherit nixpkgs home-manager nix-darwin overlays;
    };

    inherit (lib) mkNixosSystem mkDarwinSystem;

    nixosHost = mkNixosSystem {
      hostname = "nixos";
      homeModules = extraHomeModules;
      homeSpecialArgs = {inherit hyprland hyprland-plugins;};
      systemModules = [
        determinate.nixosModules.default
        hyprland.nixosModules.default
      ];
      systemSpecialArgs = {inherit hyprland;};
    };

    macMachineHost = mkDarwinSystem {
      hostname = "mac-machine";
      systemModules = [
        nix-homebrew.darwinModules.nix-homebrew
      ];
    };

    supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    nixosConfigurations.${nixosHost.name} = nixosHost.value;
    darwinConfigurations.${macMachineHost.name} = macMachineHost.value;
    homeConfigurations.${nixosHost.home.name} = nixosHost.home.value;

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
  };
}
