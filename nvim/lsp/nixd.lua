return {
  cmd = { "nixd" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "alejandra" },
      },
      options = {
        nixos = {
            expr = '(builtins.getFlake "${root}").nixosConfigurations.nixos.options',
        },
      },
    },
  },
}
