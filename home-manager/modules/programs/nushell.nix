{ pkgs, common ? null, ... }:

{
  enable = true;
  plugins = [
   pkgs.nushellPlugins.polars 
   pkgs.nushellPlugins.gstat 
   pkgs.nushellPlugins.formats 
  ];
}
