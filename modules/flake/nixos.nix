{
  self,
  inputs,
  lib,
  ...
}: let
  inherit (self.lib) mapDir;
in {
  flake = {
    nixosModules = {
      nixos = ../nixos;
      snippets = ../snippets;
    };

    nixosConfigurations = mapDir ../../hosts/nixos (
      name: value:
        inputs.nixpkgs.lib.nixosSystem {
          modules =
            [
              value.path
              inputs.home-manager.nixosModules.home-manager

              {
                home-manager = {
                  useGlobalPkgs = lib.mkDefault true;
                  useUserPackages = lib.mkDefault true;
                  extraSpecialArgs = {inherit self inputs;};
                  backupFileExtension = "backup";
                };

                nixpkgs = {
                  # overlays = [
                  #   self.overlays.default
                  #   self.inputs.nur.overlays.default
                  # ];

                  config.allowUnfree = true;
                };
              }
            ]
            ++ builtins.attrValues self.nixosModules;

          specialArgs = {inherit self inputs;};
        }
    );
  };
}
