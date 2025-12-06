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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      neovim-nightly-overlay,
      determinate,
      stylix,
      dms,
      caelestia-shell,
      ...
    }:
    let
      overlays = [
        neovim-nightly-overlay.overlays.default
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
            {
              home.username = common.username;
              home.homeDirectory = common.homeDir;
            }
            stylix.homeModules.stylix
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
          extraModules = [
            dms.homeModules.dankMaterialShell.default
            caelestia-shell.homeManagerModules.default
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
                  imports = [
                    stylix.homeModules.stylix
                    dms.homeModules.dankMaterialShell.default
                    caelestia-shell.homeManagerModules.default
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
