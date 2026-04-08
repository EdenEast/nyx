# Taken from numtide's blueprint https://github.com/numtide/blueprint/blob/main/lib/default.nix
{
  self,
  inputs,
  lib,
  ...
}: let
  nixosModules =
    [
      inputs.disko.nixosModules.disko
      inputs.golink.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.nix-index-database.nixosModules.nix-index
      inputs.nixos-wsl.nixosModules.default
      inputs.ragenix.nixosModules.default
    ]
    ++ builtins.attrValues self.nixosModules;

  hosts = let
    loadDefaultFn = {} @ inputs: inputs;
    loadDefault = hostname: path: loadDefaultFn (import path {inherit self inputs hostname;});

    loadNixOS = hostname: path: {
      path = builtins.dirOf path;
      class = "nixos";
      value = inputs.nixpkgs.lib.nixosSystem {
        modules =
          [
            path
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
          ++ nixosModules;
        specialArgs = {
          inherit inputs self hostname;
        };
      };
    };

    loadNixDarwin = hostname: path: {
      path = builtins.dirOf path;
      class = "nix-darwin";
      value = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          path
          inputs.home-manager.darwinModules.home-manager
          inputs.ragenix.darwinModules.default

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
      path = builtins.dirOf path;
      class = "home-manager";
      value = let
        system = import ((builtins.dirOf path) + "/system.nix");
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
            inputs.ragenix.homeManagerModules.default
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
      if builtins.pathExists (value + "/default.nix")
      then loadDefault name (value + "/default.nix")
      else if builtins.pathExists (value + "/configuration.nix")
      then loadNixOS name (value + "/configuration.nix")
      else if builtins.pathExists (value + "/darwin-configuration.nix")
      then loadNixDarwin name (value + "/darwin-configuration.nix")
      else if builtins.pathExis (value + "/home-configuration.nix")
      then loadHome name (value + "/home-configuration.nix")
      else throw "host '${name}' does not have a configuration";

    hostsOrNull = lib.mapAttrs loadHost (self.lib.fs.scanAttrs ../../hosts);
  in
    lib.filterAttrs (_n: v: v != null) hostsOrNull;

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

  hiveNodes = lib.mapAttrs (hostname: value: {
    imports =
      [
        (value.path + "/configuration.nix")
        (value.path + "/hive.nix")
      ]
      ++ nixosModules;

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

    _module.args.hostname = hostname;
  }) (lib.filterAttrs (_: value: value.class == "nixos" && (builtins.pathExists (value.path + "/hive.nix"))) hosts);

  colmena =
    {
      meta = {
        allowApplyAll = false;
        nixpkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          overlays = [self.overlays.default];
          config.allowUnfree = true;
        };
        specialArgs = {inherit self inputs;};
      };
    }
    // hiveNodes;
in {
  flake = {
    inherit colmena;
    colmenaHive = inputs.colmena.lib.makeHive colmena;

    homeModules = {
      default = ../home;
      snippets = ../snippets;
    };

    nixosModules = {
      nixos = ../nixos;
      snippets = ../snippets;
    };

    diskoConfigurations = self.lib.fs.scanAttrs ../disko;
    darwinConfigurations = lib.mapAttrs (_: x: x.value) (hostsByCategory.darwinConfigurations or {});
    homeConfigurations = lib.mapAttrs (_: x: x.value) (hostsByCategory.homeConfigurations or {});
    nixosConfigurations = lib.mapAttrs (_: x: x.value) (hostsByCategory.nixosConfigurations or {});
  };
}
