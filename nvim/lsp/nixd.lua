return {
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" }, -- or nixpkgs-fmt / alejandra
      },
      options = {
        nixos = {
            expr = '(builtins.getFlake "${root}").nixosConfigurations.nixos.options',
        },
      },
    },
  },
}
