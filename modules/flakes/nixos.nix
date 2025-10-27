{
  self,
  inputs,
  ...
}: let
  inherit (self.lib) forAllNixFiles;
in {
  flake = {
    nixosModules = {
      desktop = ../nixos/desktop;
      profiles = ../nixos/profiles;
      programs = ../nixos/programs;
      services = ../nixos/services;
      users = ../nixos/users;
      snippets = ../snippets;
    };

    nixosConfigurations = forAllNixFiles ../../hosts/nixos (
      name: fn:
        inputs.nixpkgs.lib.nixosSystem {
          system = import ../../hosts/nixos/${name}/system.nix;
          modules =
            [
              fn
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit self;};
                  backupFileExtension = "backup";
                };

                nixpkgs = {
                  overlays = [
                    self.overlays.default
                    self.inputs.nur.overlays.default
                  ];

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
