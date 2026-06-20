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
    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };

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

    # Neovim comes from nixpkgs (nixos-unstable), which is recent enough.
    # To switch to bleeding-edge nightly builds, re-enable the three
    # `neovim-nightly-overlay` lines marked below (this input, the outputs
    # function argument, and the overlays list entry).
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    practicalli-clojure-cli-config = {
      url = "github:practicalli/clojure-cli-config";
      flake = false;
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
  };

  outputs = {
    nixpkgs,
    home-manager,
    # neovim-nightly-overlay, # re-enable for nightly neovim (see inputs above)
    determinate,
    nix-darwin,
    nix-homebrew,
    homebrew-emacs-plus,
    stylix,
    hyprland,
    hyprland-plugins,
    noctalia,
    practicalli-clojure-cli-config,
    nix-flatpak,
    ...
  }: let
    overlays = [
      # neovim-nightly-overlay.overlays.default # re-enable for nightly neovim (see inputs above)
      (import ./nix/temporary-overlays.nix)
    ];

    # Profile registry: named, opt-in role bundles selected per-host via
    # `profiles = [ ... ]`. Orthogonal to OS family (darwin/linux) and management
    # target (nixos/darwin/generic-linux). A profile may contribute homeModules,
    # homeSpecialArgs, systemModules and systemSpecialArgs.
    profileRegistry = {
      # Any host with a display. Cross-platform GUI apps; Linux-only GUI gated inside.
      graphical.homeModules = [./nix/profiles/graphical];
    };

    lib = import ./nix/lib.nix {
      inherit
        nixpkgs
        home-manager
        nix-darwin
        overlays
        profileRegistry
        ;
      extraHomeSpecialArgs = {inherit practicalli-clojure-cli-config;};
    };

    inherit (lib) mkNixosSystem mkDarwinSystem mkHomeConfiguration;

    ci = import ./nix/checks.nix {
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
        profiles = ["graphical"];
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
        profiles = ["graphical"];
        systemModules = [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew.taps = {
              "d12frosted/homebrew-emacs-plus" = homebrew-emacs-plus;
            };
          }
        ];
      };
    };

    homeConfigurations = {
      "zekus@nixos" = mkHomeConfiguration {
        hostname = "nixos";
        system = "x86_64-linux";
        profiles = ["graphical"];
        homeModules = nixosHomeModules;
        homeSpecialArgs = nixosHomeSpecialArgs;
      };
    };

    inherit (ci) checks formatter devShells;
  };
}
