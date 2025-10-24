{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosConfigurations = with builtins;
      mapAttrs (name: _:
        inputs.nixpkgs.lib.nixosSystem {
          system = ./nixos/${name}/system;
          modules = [
            ./nixos/${name}
          ];
          specialArgs = {inherit self inputs;};
        })
      (readDir ./nixos);
  };
}
