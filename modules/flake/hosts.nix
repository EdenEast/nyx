# Taken from numtide's blueprint https://github.com/numtide/blueprint/blob/main/lib/default.nix
{
  self,
  inputs,
  lib,
  ...
}: let
  inherit (self.lib) importDir;

  hosts = importDir ../../hosts (
    entries: let
      loadDefaultFn = {} @ inputs:
        inputs;
      loadDefault = hostname: path: loadDefaultFn (import path {inherit self inputs hostname;});

      loadNixOS = hostname: path: {
        class = "nixos";
        value = inputs.nixpkgs.lib.nixosSystem {
          modules =
            [
              path
              inputs.home-manager.nixosModules.home-manager
              inputs.nix-index-database.nixosModules.nix-index

              {
                nixpkgs = {
                  overlays = [
                    self.overlays.default
                  ];

                  config.allowUnfree = true;
                };

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = {
                    inherit self inputs hostname;
                  };
                };
              }
            ]
            ++ builtins.attrValues self.nixosModules;
          specialArgs = {
            inherit inputs self hostname;
          };
        };
      };

      loadNixDarwin = hostname: path: {
        class = "nix-darwin";
        value = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            path
            inputs.home-manager.darwinModules.home-manager
            {
              nixpkgs = {
                overlays = [
                  self.overlays.default
                ];

                config.allowUnfree = true;
              };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit self inputs hostname;
                };
              };
            }
          ];
          specialArgs = {
            inherit inputs self hostname;
          };
        };
      };

      loadHome = username: path: {
        class = "home-manager";
        value = let
          system = import ((builtins.dirOf path) + "/system.nix");
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];

            config.allowUnfree = true;
          };
          homeDirectory =
            if pkgs.stdenv.isDarwin
            then "/Users/${username}"
            else "/home/${username}";
        in
          inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              path
              {
                imports = builtins.attrValues self.homeModules;
                home = {inherit username homeDirectory;};
              }
            ];

            extraSpecialArgs = {
              inherit inputs self username;
            };
          };
      };

      loadHost = name: value:
        if builtins.pathExists (value.path + "/default.nix")
        then loadDefault name (value.path + "/default.nix")
        else if builtins.pathExists (value.path + "/configuration.nix")
        then loadNixOS name (value.path + "/configuration.nix")
        else if builtins.pathExists (value.path + "/darwin-configuration.nix")
        then loadNixDarwin name (value.path + "/darwin-configuration.nix")
        else if builtins.pathExists (value.path + "/home-configuration.nix")
        then loadHome name (value.path + "/home-configuration.nix")
        else throw "host '${name}' does not have a configuration";

      hostsOrNull = lib.mapAttrs loadHost entries;
    in
      lib.filterAttrs (_n: v: v != null) hostsOrNull
  );

  hostsByCategory = lib.mapAttrs (_: hosts: lib.listToAttrs hosts) (
    builtins.groupBy (
      x:
        if x.value.class == "nixos"
        then "nixosConfigurations"
        else if x.value.class == "nix-darwin"
        then "darwinConfigurations"
        else if x.value.class == "home-manager"
        then "homeConfigurations"
        else throw "host '${x.name}' of class '${x.value.class or "unknown"}' not supported"
    ) (lib.attrsToList hosts)
  );
in {
  flake = {
    homeModules = {
      default = ../home;
      snippets = ../snippets;
    };

    nixosModules = {
      nixos = ../nixos;
      snippets = ../snippets;
    };

    homeConfigurations = lib.mapAttrs (_: x: x.value) (hostsByCategory.homeConfigurations or {});
    darwinConfigurations = lib.mapAttrs (_: x: x.value) (hostsByCategory.darwinConfigurations or {});
    nixosConfigurations = lib.mapAttrs (_: x: x.value) (hostsByCategory.nixosConfigurations or {});
  };
}
