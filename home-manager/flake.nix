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
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              nixpkgs.overlays = overlays;
              nixpkgs.config.allowUnfree = true;
            }
            ./hosts/${hostname}.nix
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

      };
    };
}
