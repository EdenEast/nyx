{
  description = "Eden's home configuration";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... } @ inputs:
    with builtins;
    with inputs.nixpkgs.lib;
    let
      forEachSystem = genAttrs [ "x86_64-linux" "aarch64-linux" ];
      pkgsBySystem = forEachSystem (system:
        import inputs.nixpkgs {
          inherit system;
          config = import ./nix/config.nix;
        });

      mkHomeManagerConfiguration = name:
        { system, config }:
        nameValuePair name ({ ... }: {
          imports = [
            (import ./home/configs)
            (import ./home/modules)
            (import ./home/profiles)
            (import ./home/users)
            (import config)
          ];

          # For compat with nix-shell, nix-build, etc
          home.file."nixpkgs".source = inputs.nixpkgs;

          # Use the same nix config
          xdg.configFile."nixpkgs/config.nix".source = ./nix/config.nix;
        });

      mkHomeManagerHostConfiguration = name:
        { system }:
        nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
          inherit system;
          configuration = { ... }: {
            imports = [ self.internal.homeManagerConfigurations."${name}" ];
            nixpkgs = { config = import ./nix/config.nix; };
          };

          # TODO: Use nyx.users to set this depending of the host that was configured
          # username = config.nyx.users.username;
          # homeDirectory = config.nyx.users.homeDirectory;
          username = "eden";
          homeDirectory = "/home/eden";
          pkgs = pkgsBySystem."${system}";
        });

    in {
      internal = {
        # Attribute set of hostnames to home-manager modules with the entire configuration for
        # that host - consumed by the home-manager NixOS module for that host (if it exists)
        # or by `mkHomeManagerHostConfiguration` for home-manager-only hosts.
        homeManagerConfigurations = mapAttrs' mkHomeManagerConfiguration {
          wsl = { system = "x86_64-linux"; config = ./home/hosts/wsl.nix; };
        };

        homeConfiguration = forEachSystem (system: {
          wsl = mkHomeManagerHostConfiguration "wsl" { inherit system; };
        });
      };

      wsl = self.internal.homeConfiguration.x86_64-linux.wsl.value.activationPackage;

      defaultPackage.x86_64-linux = self.wsl;
    };
}
