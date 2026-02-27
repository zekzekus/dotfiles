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
    homeModules ? [],
    homeSpecialArgs ? {},
  }: let
    username = defaultUsername;
    homeDir = mkHomeDir {inherit system username;};
    common = mkCommon {inherit username homeDir;};

    allHomeModules =
      homeModules
      ++ [./home.nix]
      ++ nixpkgs.lib.optional (isDarwin system) ./platforms/darwin
      ++ nixpkgs.lib.optional (isLinux system) ./platforms/linux
      ++ [./hosts/${hostname}];
  in {
    inherit hostname system;
    home = {
      modules = allHomeModules;
      specialArgs = {inherit common;} // homeSpecialArgs;
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
    homeModules ? [],
    homeSpecialArgs ? {},
    systemModules ? [],
    systemSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system homeModules homeSpecialArgs;};
    inherit (host.home.specialArgs) common;
  in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = systemSpecialArgs // {inherit common;};
      modules =
        systemModules
        ++ [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.home-manager
          (mkHmModule host)
        ];
    };

  mkDarwinSystem = {
    hostname,
    system ? "aarch64-darwin",
    homeModules ? [],
    homeSpecialArgs ? {},
    systemModules ? [],
    systemSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system homeModules homeSpecialArgs;};
    inherit (host.home.specialArgs) common;
  in
    nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = systemSpecialArgs // {inherit common;};
      modules =
        systemModules
        ++ [
          ./hosts/${hostname}/configuration.nix
          home-manager.darwinModules.home-manager
          (mkHmModule host)
        ];
    };

  mkHomeConfiguration = {
    hostname,
    system,
    homeModules ? [],
    homeSpecialArgs ? {},
  }: let
    host = mkHost {inherit hostname system homeModules homeSpecialArgs;};
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      inherit (host.home) modules;
      extraSpecialArgs = host.home.specialArgs;
    };
in {
  inherit
    mkNixosSystem
    mkDarwinSystem
    mkHomeConfiguration
    ;
}
