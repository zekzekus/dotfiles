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
        inherit nixpkgs home-manager nix-darwin overlays;
      };

      inherit (lib) mkNixosSystem mkDarwinSystem;

      # Host definitions - hostname is specified once per host
      nixosHost = mkNixosSystem {
        hostname = "nixos";
        extraModules = nixosExtraModules;
        extraSpecialArgs = { inherit hyprland hyprland-plugins; };
        systemModules = [
          determinate.nixosModules.default
          hyprland.nixosModules.default
        ];
        systemSpecialArgs = { inherit hyprland; };
      };

      macMachineHost = mkDarwinSystem {
        hostname = "mac-machine";
        systemModules = [
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

    in
    {
      nixosConfigurations.${nixosHost.name} = nixosHost.value;
      darwinConfigurations.${macMachineHost.name} = macMachineHost.value;

      # Standalone HM configurations for non-NixOS/non-darwin hosts (WSL, generic Linux, etc.)
      # homeConfigurations = builtins.listToAttrs [
      #   (mkHomeConfiguration { hostname = "wsl"; system = "x86_64-linux"; })
      # ];
    };
}
