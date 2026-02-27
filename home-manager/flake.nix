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

    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
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
    nix-flatpak,
    ...
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default
      (_: prev: {
        python3Packages = prev.python3Packages.overrideScope (
          _: pyPrev: {
            picosvg = pyPrev.picosvg.overridePythonAttrs {
              doCheck = false;
            };
          }
        );
      })
    ];

    lib = import ./lib.nix {
      inherit
        nixpkgs
        home-manager
        nix-darwin
        overlays
        ;
    };

    inherit (lib) mkNixosSystem mkDarwinSystem mkHomeConfiguration;

    ci = import ./checks.nix {
      inherit nixpkgs;
      supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    };

    nixosHomeModules = [
      stylix.homeModules.stylix
      hyprland.homeManagerModules.default
      noctalia.homeModules.default
    ];
    nixosHomeSpecialArgs = {inherit hyprland hyprland-plugins;};
  in {
    nixosConfigurations = {
      nixos = mkNixosSystem {
        hostname = "nixos";
        homeModules = nixosHomeModules;
        homeSpecialArgs = nixosHomeSpecialArgs;
        systemModules = [
          determinate.nixosModules.default
          hyprland.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
        ];
        systemSpecialArgs = {inherit hyprland;};
      };
    };

    darwinConfigurations = {
      mac-machine = mkDarwinSystem {
        hostname = "mac-machine";
        systemModules = [
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };
    };

    homeConfigurations = {
      "zekus@nixos" = mkHomeConfiguration {
        hostname = "nixos";
        system = "x86_64-linux";
        homeModules = nixosHomeModules;
        homeSpecialArgs = nixosHomeSpecialArgs;
      };
    };

    inherit (ci) checks formatter;
  };
}
