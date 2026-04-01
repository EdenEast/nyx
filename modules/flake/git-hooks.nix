{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];
  perSystem = _: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };
}
