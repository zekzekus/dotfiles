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

    hey-cli = {
      url = "github:basecamp/hey-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encrypted secrets (age-backed). Provides the home-manager `sops` module,
    # wired into the base layer in nix/lib.nix so every host can decrypt secrets.
    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    practicalli-clojure-cli-config = {
      url = "github:practicalli/clojure-cli-config";
      flake = false;
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
  };

  outputs = {
    nixpkgs,
    home-manager,
    hey-cli,
    sops-nix,
    determinate,
    nix-darwin,
    nix-homebrew,
    homebrew-emacs-plus,
    stylix,
    hyprland,
    hyprland-plugins,
    practicalli-clojure-cli-config,
    nix-flatpak,
    ...
  }: let
    overlays = [
      (import ./nix/temporary-overlays.nix)
    ];

    # Profile registry: named, opt-in role bundles selected per-host via
    # `profiles = [ ... ]`. Orthogonal to OS family (darwin/linux) and management
    # target (nixos/darwin/generic-linux). A profile may contribute homeModules,
    # homeSpecialArgs, systemModules and systemSpecialArgs.
    profileRegistry = {
      # Any host with a display. Cross-platform GUI apps; Linux-only GUI gated inside.
      graphical.homeModules = [./nix/profiles/graphical];

      # Hyprland/Niri/Noctalia Wayland session (home-manager side). Bundles the
      # external Hyprland module and inputs it needs; Noctalia's module is
      # provided by nixpkgs. Normally paired with "graphical".
      wayland = {
        homeModules = [
          stylix.homeModules.stylix
          hyprland.homeManagerModules.default
          ./nix/profiles/wayland
        ];
        homeSpecialArgs = {inherit hyprland hyprland-plugins;};
      };
    };

    lib = import ./nix/lib.nix {
      inherit
        nixpkgs
        home-manager
        sops-nix
        nix-darwin
        overlays
        profileRegistry
        ;
      extraHomeSpecialArgs = {inherit hey-cli practicalli-clojure-cli-config;};
    };

    inherit (lib) mkNixosSystem mkDarwinSystem mkHomeConfiguration;

    ci = import ./nix/checks.nix {
      inherit nixpkgs;
      supportedSystems = ["x86_64-linux" "aarch64-darwin"];
    };

    # Hosts: one entry per machine — the single source of truth for its system,
    # profiles, and system-level wiring. Every output below derives from this,
    # so a machine that appears in several outputs (e.g. `nixos` in both
    # nixosConfigurations and homeConfigurations) can never drift. Every entry
    # declares hostname, system and profiles (use [] for headless).
    hosts = {
      nixos = {
        hostname = "nixos";
        system = "x86_64-linux";
        profiles = ["graphical" "wayland"];
        systemModules = [
          determinate.nixosModules.default
          hyprland.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
        ];
        systemSpecialArgs = {inherit hyprland;};
      };

      mac-machine = {
        hostname = "mac-machine";
        system = "aarch64-darwin";
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

    nixosConfigurations = {
      nixos = mkNixosSystem hosts.nixos;
    };

    darwinConfigurations = {
      mac-machine = mkDarwinSystem hosts.mac-machine;
    };

    homeConfigurations = {
      "zekus@nixos" = mkHomeConfiguration {
        inherit (hosts.nixos) hostname system profiles;
        target = "nixos"; # standalone HM on NixOS — do NOT enable genericLinux
      };
    };

    # `nix flake check` evaluates nixosConfigurations on its own, but skips the
    # non-standard darwinConfigurations/homeConfigurations outputs. These checks
    # force full evaluation (instantiation only — nothing is built) so eval
    # breakage in those configs surfaces in `make check`.
    mkEvalCheck = system: name: drv: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.runCommand "eval-${name}" {} ''
        echo ${builtins.unsafeDiscardStringContext drv.drvPath} > $out
      '';

    evalChecks = {
      x86_64-linux.eval-home-zekus-nixos =
        mkEvalCheck "x86_64-linux" "home-zekus-nixos"
        homeConfigurations."zekus@nixos".activationPackage;
      aarch64-darwin.eval-darwin-mac-machine =
        mkEvalCheck "aarch64-darwin" "darwin-mac-machine"
        darwinConfigurations.mac-machine.system;
    };
  in {
    inherit nixosConfigurations darwinConfigurations homeConfigurations;

    checks = nixpkgs.lib.recursiveUpdate ci.checks evalChecks;
    inherit (ci) formatter devShells;
  };
}
