{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem.treefmt.programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
