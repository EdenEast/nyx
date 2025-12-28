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
      name: value: let
        hostName = name;
      in
        inputs.nixpkgs.lib.nixosSystem {
          modules =
            [
              value.path
              inputs.home-manager.nixosModules.home-manager
              inputs.nix-index-database.nixosModules.nix-index

              {
                home-manager = {
                  useGlobalPkgs = lib.mkDefault true;
                  useUserPackages = lib.mkDefault true;
                  extraSpecialArgs = {inherit self inputs hostName;};
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

          specialArgs = {inherit self inputs hostName;};
        }
    );
  };
}
