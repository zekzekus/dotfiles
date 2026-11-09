# Local source evaluation only: no getFlake, input resolution or module eval.
{
  repo,
  target,
  output,
}: let
  definition = import (repo + "/flake.nix");
  setup = (definition.outputs (builtins.mapAttrs (_: _: {}) (builtins.functionArgs definition.outputs))).lib.setup;
  available = setup.outputs.${target};
  homeMatch = builtins.match "[^@]+@(.+)" output;
  hostname =
    if target == "home" && homeMatch != null
    then builtins.head homeMatch
    else output;
  host =
    if !(builtins.elem output available)
    then throw "No ${target} output '${output}'. Available: ${builtins.concatStringsSep ", " available}. Add/export a new host before setup; see nix/README.md."
    else if !(builtins.hasAttr hostname setup.hosts)
    then throw "Output '${output}' has no matching hosts.${hostname} registry entry."
    else setup.hosts.${hostname};
  missingProfiles = builtins.filter (p: !(builtins.elem p setup.profiles)) host.profiles;
  inherit (host) common;
  line = fields: builtins.concatStringsSep "\t" fields;
in
  assert missingProfiles == [] || throw "Unknown profiles: ${builtins.concatStringsSep ", " missingProfiles}";
    builtins.concatStringsSep "\n" [
      (line ["system" host.system])
      (line ["user" common.username])
      (line ["home" common.homeDir])
      (line ["checkout" common.dotfilesDir])
      (line ["age" common.sessionVariables.SOPS_AGE_KEY_FILE])
      (line ["host" host.hostname])
    ]
    + "\n"
