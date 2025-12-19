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

      mkCommon =
        { username, homeDir }:
        {
          inherit username homeDir;
          dotfilesDir = "${homeDir}/devel/tools/dotfiles";
          develHome = "${homeDir}/devel/projects";
          defaultProjectDir = "personal";
          workHome = "${homeDir}/devel/projects/personal";
          personalHome = "${homeDir}/devel/projects/personal";
        };

      mkHomeConfiguration =
        {
          system,
          hostname,
          username ? "zekus",
          extraModules ? [ ],
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = overlays;
            config.allowUnfree = true;
          };
          homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
          common = mkCommon { inherit username homeDir; };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit common; };
          modules = [
            ./home.nix
          ]
          ++ nixpkgs.lib.optional pkgs.stdenv.isDarwin ./platforms/darwin
          ++ nixpkgs.lib.optional pkgs.stdenv.isLinux ./platforms/linux
          ++ extraModules
          ++ [ ./hosts/${hostname} ];
        };

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
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "zekus";
                autoMigrate = true;
              };
            }
            ./hosts/mac-machine/darwin.nix
            home-manager.darwinModules.home-manager
            (
              let
                common = mkCommon {
                  username = "zekus";
                  homeDir = "/Users/zekus";
                };
              in
              {
                nixpkgs.overlays = overlays;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit common; };
                home-manager.users.zekus = {
                  imports = [
                    ./home.nix
                    ./platforms/darwin
                    ./hosts/mac-machine
                  ];
                };
              }
            )
          ];
        };
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { };
          modules = [
            determinate.nixosModules.default
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zekus =
                { ... }:
                {
                  imports = nixosExtraModules ++ [
                    ./home.nix
                    ./platforms/linux
                    ./hosts/nixos
                  ];
                };
              home-manager.extraSpecialArgs = {
                common = mkCommon {
                  username = "zekus";
                  homeDir = "/home/zekus";
                };
              };
            }
          ];
        };
      };
    };
}