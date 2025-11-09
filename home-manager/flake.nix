{
  description = "Home Manager configuration of zekus";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://cache.flakehub.com"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
  };

  outputs = { nixpkgs, home-manager, neovim-nightly-overlay, determinate, ... }:
    let
      overlays = [
        neovim-nightly-overlay.overlays.default
      ];

      mkCommon = { username, homeDir }: {
        inherit username homeDir;
        dotfilesDir = "${homeDir}/devel/tools/dotfiles";
        develHome = "${homeDir}/devel/projects";
        defaultProjectDir = "personal";
        workHome = "${homeDir}/devel/projects/personal";
        personalHome = "${homeDir}/devel/projects/personal";
      };

      mkHomeConfiguration = { system, hostname, username ? "zekus" }:
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
            ./home.nix
          ] ++ nixpkgs.lib.optional pkgs.stdenv.isDarwin ./modules/platform/darwin.nix
            ++ nixpkgs.lib.optional pkgs.stdenv.isLinux ./modules/platform/linux.nix
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
        };
      };

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            determinate.nixosModules.default
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zekus = { ... }: {
                imports = [
                  ./home.nix
                  ./modules/platform/linux.nix
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
