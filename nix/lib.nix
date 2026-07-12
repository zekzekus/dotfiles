{
  nixpkgs,
  home-manager,
  sops-nix,
  nix-darwin,
  overlays,
  profileRegistry ? {},
  extraHomeSpecialArgs ? {},
}: let
  defaultUsername = "zekus";

  mkCommon = {
    username,
    homeDir,
  }: let
    dotfilesDir = "${homeDir}/devel/tools/dotfiles";
    develHome = "${homeDir}/devel/projects";
    defaultProjectDir = "personal";
    workHome = "${homeDir}/devel/projects/work";
    personalHome = "${homeDir}/devel/projects/personal";
  in {
    inherit username homeDir dotfilesDir develHome defaultProjectDir workHome personalHome;

    userFullName = "Zekeriya Koc";
    userEmail = "zekzekus@gmail.com";
    gpgKey = "6716516470AD2D7A";

    sessionVariables = {
      ZEK_DEVEL_HOME = develHome;
      ZEK_DEFAULT_PROJECT_DIR = defaultProjectDir;
      ZEK_DEVEL_WORK_HOME = workHome;
      ZEK_DEVEL_PERSONAL_HOME = personalHome;

      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";

      PNPM_HOME = "${homeDir}/.local/share/pnpm";

      CLJ_CONFIG = "${homeDir}/.config/clojure";

      SSH_AUTH_SOCK = "${homeDir}/.1password/agent.sock";
      NH_FLAKE = dotfilesDir;

      # sops-nix decrypts from here (set in ssh.nix); also point the `sops` CLI
      # at it so `sops edit` works. The CLI's macOS default is ~/Library/...,
      # which would otherwise miss this Linux-native location.
      SOPS_AGE_KEY_FILE = "${homeDir}/.config/sops/age/keys.txt";
    };

    sessionPath = [
      "${homeDir}/bin"
      "${homeDir}/.config/emacs/bin"
      "${homeDir}/.local/share/pnpm/bin"
      "${homeDir}/.local/share/coursier/bin"
    ];
  };

  mkHomeDir = {
    system,
    username,
  }:
    if (builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
    then "/Users/${username}"
    else "/home/${username}";

  isDarwin = system: builtins.elem system ["aarch64-darwin" "x86_64-darwin"];
  isLinux = system: builtins.elem system ["x86_64-linux" "aarch64-linux"];

  # Profiles are named, opt-in bundles of modules (and specialArgs) defined in the
  # `profileRegistry` (see flake.nix) and selected per-host via `profiles = [ ... ]`.
  # A profile may contribute: homeModules, homeSpecialArgs, systemModules,
  # systemSpecialArgs. This is the third axis (role) orthogonal to OS family and
  # management target, e.g. "graphical", "wayland".
  resolveProfiles = profiles: let
    known = builtins.attrNames profileRegistry;
    missing = builtins.filter (p: !(builtins.elem p known)) profiles;
  in
    if missing != []
    then throw "Unknown profile(s): ${builtins.concatStringsSep ", " missing}. Known profiles: ${builtins.concatStringsSep ", " known}"
    else map (p: profileRegistry.${p}) profiles;

  profileHomeModules = ps: nixpkgs.lib.concatMap (p: p.homeModules or []) ps;
  profileSystemModules = ps: nixpkgs.lib.concatMap (p: p.systemModules or []) ps;
  profileHomeSpecialArgs = ps: nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate {} (map (p: p.homeSpecialArgs or {}) ps);
  profileSystemSpecialArgs = ps: nixpkgs.lib.foldl' nixpkgs.lib.recursiveUpdate {} (map (p: p.systemSpecialArgs or {}) ps);

  mkHost = {
    hostname,
    system,
    profiles ? [],
    homeModules ? [],
    homeSpecialArgs ? {},
  }: let
    username = defaultUsername;
    homeDir = mkHomeDir {inherit system username;};
    common =
      (mkCommon {inherit username homeDir;})
      // {
        isLinux = isLinux system;
        isDarwin = isDarwin system;
      };
    resolvedProfiles = resolveProfiles profiles;

    allHomeModules =
      homeModules
      ++ [sops-nix.homeManagerModules.sops ./home.nix]
      ++ nixpkgs.lib.optional (isDarwin system) ./platforms/darwin
      ++ nixpkgs.lib.optional (isLinux system) ./platforms/linux
      ++ profileHomeModules resolvedProfiles
      ++ [./hosts/${hostname}];
  in {
    inherit hostname system;
    home = {
      modules = allHomeModules;
      specialArgs = {inherit common;} // extraHomeSpecialArgs // profileHomeSpecialArgs resolvedProfiles // homeSpecialArgs;
      inherit username;
    };
  };

  mkHmModule = host: {
    nixpkgs.overlays = overlays;
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${host.home.username} = {...}: {
        imports = host.home.modules;
      };
      extraSpecialArgs = host.home.specialArgs;
    };
  };

  mkNixosSystem = {
    hostname,
    system ? "x86_64-linux",
    profiles ? [],
    homeModules ? [],
    homeSpecialArgs ? {},
    systemModules ? [],
    systemSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system profiles homeModules homeSpecialArgs;};
    inherit (host.home.specialArgs) common;
    resolvedProfiles = resolveProfiles profiles;
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = profileSystemSpecialArgs resolvedProfiles // systemSpecialArgs // {inherit common;};
      modules =
        systemModules
        ++ profileSystemModules resolvedProfiles
        ++ [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          (mkHmModule host)
        ];
    };

  mkDarwinSystem = {
    hostname,
    system ? "aarch64-darwin",
    profiles ? [],
    homeModules ? [],
    homeSpecialArgs ? {},
    systemModules ? [],
    systemSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system profiles homeModules homeSpecialArgs;};
    inherit (host.home.specialArgs) common;
    resolvedProfiles = resolveProfiles profiles;
  in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = profileSystemSpecialArgs resolvedProfiles // systemSpecialArgs // {inherit common;};
      modules =
        systemModules
        ++ profileSystemModules resolvedProfiles
        ++ [
          ./platforms/darwin/configuration.nix
          ./hosts/${hostname}/configuration.nix
          home-manager.darwinModules.home-manager
          (mkHmModule host)
        ];
    };

  mkHomeConfiguration = {
    hostname,
    system,
    profiles ? [],
    # Management target — drives non-NixOS integration. Auto-detected: standalone
    # HM on a foreign Linux distro defaults to "generic-linux". Pass target =
    # "nixos" for standalone HM on NixOS, otherwise genericLinux would wrongly
    # enable (and assert) on a NixOS box.
    target ? (
      if isLinux system
      then "generic-linux"
      else "standalone"
    ),
    homeModules ? [],
    homeSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system profiles homeModules homeSpecialArgs;};
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
    # Non-NixOS Linux integration: FHS XDG data dirs, session-var/nix.sh sourcing,
    # cursor paths, etc. Only valid/needed for standalone HM on a foreign distro.
    genericLinuxModule = {lib, ...}: {
      targets.genericLinux.enable = true;
      # Headless-safe: HM otherwise defaults gpu.enable to true, pulling in the
      # non-NixOS GPU driver setup package + an activation warning. Graphical
      # foreign hosts opt back in (gpu.enable = true, then `sudo non-nixos-gpu`)
      # or wrap individual GUI packages with nixGL.
      targets.genericLinux.gpu.enable = lib.mkDefault false;
    };
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = host.home.modules ++ nixpkgs.lib.optional (target == "generic-linux") genericLinuxModule;
      extraSpecialArgs = host.home.specialArgs;
    };
in {
  inherit
    mkNixosSystem
    mkDarwinSystem
    mkHomeConfiguration
    ;
}
