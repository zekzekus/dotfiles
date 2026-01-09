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

  outputs =
    {
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
    }:
    let
      overlays = [
        neovim-nightly-overlay.overlays.default
      ];

      nixosExtraModules = [
        stylix.homeModules.stylix
        hyprland.homeManagerModules.default 
        noctalia.homeModules.default
      ];

      lib = import ./lib.nix {
        inherit nixpkgs home-manager overlays;
      };

      inherit (lib) defaultUsername mkHmModule mkHomeConfiguration;

    in
    {
      homeConfigurations = {
        "zekus@nixos" = mkHomeConfiguration {
          system = "x86_64-linux";
          hostname = "nixos";
          extraModules = nixosExtraModules;
          extraSpecialArgs = { inherit hyprland hyprland-plugins; };
        };
      };

      darwinConfigurations = {
        "mac-machine" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            nix-homebrew.darwinModules.nix-homebrew
            ./hosts/mac-machine/configuration.nix
            home-manager.darwinModules.home-manager
            (mkHmModule {
              username = defaultUsername;
              homeDir = "/Users/${defaultUsername}";
              platformPath = ./platforms/darwin;
              hostPath = ./hosts/mac-machine;
            })
          ];
        };
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit hyprland; };
          modules = [
            determinate.nixosModules.default
            hyprland.nixosModules.default
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHmModule {
              username = defaultUsername;
              homeDir = "/home/${defaultUsername}";
              platformPath = ./platforms/linux;
              hostPath = ./hosts/nixos;
              extraModules = nixosExtraModules;
              extraSpecialArgs = { inherit hyprland hyprland-plugins; };
            })
          ];
        };
      };
    };
}
