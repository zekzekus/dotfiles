{
  description = "Home Manager configuration of zekus";

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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      dms,
      caelestia-shell,
      noctalia,
      ...
    }:
    let
      overlays = [
        neovim-nightly-overlay.overlays.default
      ];

      nixosExtraModules = [
        stylix.homeModules.stylix
        dms.homeModules.dank-material-shell
        caelestia-shell.homeManagerModules.default
        noctalia.homeModules.default
      ];

      lib = import ./lib.nix {
        inherit nixpkgs home-manager overlays;
        dotfilesDir = ./..;
      };

      inherit (lib) defaultUsername mkHmModule mkHomeConfiguration;

    in
    {
      homeConfigurations = {
        "zekus@zomarchy" = mkHomeConfiguration {
          system = "x86_64-linux";
          hostname = "zomarchy";
        };

        "zekus@mac-machine" = mkHomeConfiguration {
          system = "aarch64-darwin";
          hostname = "mac-machine";
        };

        "zekus@nixos" = mkHomeConfiguration {
          system = "x86_64-linux";
          hostname = "nixos";
          extraModules = nixosExtraModules;
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
              homeDir = "/Users/${defaultUsername}";
              username = defaultUsername;
              platformPath = ./platforms/darwin;
              hostPath = ./hosts/mac-machine;
            })
          ];
        };
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            determinate.nixosModules.default
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            (mkHmModule {
              homeDir = "/home/${defaultUsername}";
              username = defaultUsername;
              platformPath = ./platforms/linux;
              hostPath = ./hosts/nixos;
              extraImports = nixosExtraModules;
            })
          ];
        };
      };
    };
}
