# Shared Darwin policy supplies stateVersion, primaryUser, Homebrew and defaults.
# Requires an existing zekus administrator account and Determinate Nix.
# Review Homebrew cleanup = "zap" before the first activation.
_: {
  networking = {
    hostName = "example-darwin";
    computerName = "example-darwin";
    localHostName = "example-darwin";
  };
}
