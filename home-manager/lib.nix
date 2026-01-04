{
  nixpkgs,
  home-manager,
  overlays,
  ...
}:
let
  defaultUsername = "zekus";

  mkCommon =
    { username, homeDir }:
    {
      inherit username homeDir;
      dotfilesDir = "${homeDir}/devel/tools/dotfiles";
      develHome = "${homeDir}/devel/projects";
      defaultProjectDir = "personal";
      workHome = "${homeDir}/devel/projects/work";
      personalHome = "${homeDir}/devel/projects/personal";
    };

  mkHomeDir = { system, username }:
    if (builtins.elem system [ "aarch64-darwin" "x86_64-darwin" ])
    then "/Users/${username}"
    else "/home/${username}";

  mkHmModule =
    { username, homeDir, platformPath, hostPath, extraModules ? [], extraSpecialArgs ? {} }:
    {
      nixpkgs.overlays = overlays;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} =
        { ... }:
        {
          imports = extraModules ++ [
            ./home.nix
            platformPath
            hostPath
          ];
        };
      home-manager.extraSpecialArgs = {
        common = mkCommon { inherit username homeDir; };
      } // extraSpecialArgs;
    };

  mkHomeConfiguration =
    {
      system,
      hostname,
      username ? defaultUsername,
      extraModules ? [],
      extraSpecialArgs ? {},
    }:
    let
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
      homeDir = mkHomeDir { inherit system username; };
      common = mkCommon { inherit username homeDir; };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit common; } // extraSpecialArgs;
      modules = extraModules ++ [
        ./home.nix
      ]
      ++ nixpkgs.lib.optional pkgs.stdenv.isDarwin ./platforms/darwin
      ++ nixpkgs.lib.optional pkgs.stdenv.isLinux ./platforms/linux
      ++ [ ./hosts/${hostname} ];
    };

in
{
  inherit
    defaultUsername
    mkCommon
    mkHomeDir
    mkHmModule
    mkHomeConfiguration;
}