{
  description = "Home Manager configuration of zekus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, neovim-nightly-overlay, ... }:
    let
      overlays = [
        neovim-nightly-overlay.overlays.default
      ];

      mkHomeConfiguration = { system, hostname, username ? "zekus" }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = overlays;
            config.allowUnfree = true;
          };
          homeDir = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
          common = {
            inherit username homeDir;
            dotfilesDir = "${homeDir}/devel/tools/dotfiles";
            develHome = "${homeDir}/devel/projects";
            defaultProjectDir = "personal";
            workHome = "${homeDir}/devel/projects/personal";
            personalHome = "${homeDir}/devel/projects/personal";
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit common; };
          modules = [
            {
              home.username = common.username;
              home.homeDirectory = common.homeDir;
            }
            ./hosts/${hostname}
          ];
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
            ./hosts/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zekus = import ./hosts/nixos;
              home-manager.extraSpecialArgs = {
                common = {
                  username = "zekus";
                  homeDir = "/home/zekus";
                  dotfilesDir = "/home/zekus/devel/tools/dotfiles";
                  develHome = "/home/zekus/devel/projects";
                  defaultProjectDir = "personal";
                  workHome = "/home/zekus/devel/projects/personal";
                  personalHome = "/home/zekus/devel/projects/personal";
                };
              };
            }
          ];
        };
      };
    };
}
