{
  nixpkgs,
  home-manager,
  nix-darwin,
  overlays,
}: let
  defaultUsername = "zekus";

  mkCommon = {
    username,
    homeDir,
  }: {
    inherit username homeDir;
    dotfilesDir = "${homeDir}/devel/tools/dotfiles";
    develHome = "${homeDir}/devel/projects";
    defaultProjectDir = "personal";
    workHome = "${homeDir}/devel/projects/work";
    personalHome = "${homeDir}/devel/projects/personal";
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

  mkHost = {
    hostname,
    system,
    extraModules ? [],
    extraSpecialArgs ? {},
  }: let
    username = defaultUsername;
    homeDir = mkHomeDir {inherit system username;};
    common = mkCommon {inherit username homeDir;};

    homeModules =
      extraModules
      ++ [./home.nix]
      ++ nixpkgs.lib.optional (isDarwin system) ./platforms/darwin
      ++ nixpkgs.lib.optional (isLinux system) ./platforms/linux
      ++ [./hosts/${hostname}];
  in {
    inherit hostname system;
    home = {
      modules = homeModules;
      specialArgs = {inherit common;} // extraSpecialArgs;
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
    extraModules ? [],
    extraSpecialArgs ? {},
    systemModules ? [],
    systemSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system extraModules extraSpecialArgs;};
  in {
    name = hostname;
    value = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = systemSpecialArgs;
      modules =
        systemModules
        ++ [
          ./platforms/linux/system.nix
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          (mkHmModule host)
        ];
    };
  };

  mkDarwinSystem = {
    hostname,
    system ? "aarch64-darwin",
    extraModules ? [],
    extraSpecialArgs ? {},
    systemModules ? [],
  }: let
    host = mkHost {inherit hostname system extraModules extraSpecialArgs;};
  in {
    name = hostname;
    value = nix-darwin.lib.darwinSystem {
      inherit system;
      modules =
        systemModules
        ++ [
          ./platforms/darwin/system.nix
          ./hosts/${hostname}/configuration.nix
          home-manager.darwinModules.home-manager
          (mkHmModule host)
        ];
    };
  };

  mkHomeConfiguration = {
    hostname,
    system,
    extraModules ? [],
    extraSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system extraModules extraSpecialArgs;};
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in {
    name = "${defaultUsername}@${hostname}";
    value = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      inherit (host.home) modules;
      extraSpecialArgs = host.home.specialArgs;
    };
  };
in {
  inherit
    defaultUsername
    overlays
    mkNixosSystem
    mkDarwinSystem
    mkHomeConfiguration
    ;
}
