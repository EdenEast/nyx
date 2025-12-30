{inputs, ...}: {
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];
  perSystem = _: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };
}
