{ inputs, ... }:

with inputs.nixpkgs.lib;
let
  strToPath = x: path:
    if builtins.typeOf x == "string"
    then builtins.toPath ("${toString path}/${x}")
    else x;
  strToFile = x: path:
    if builtins.typeOf x == "string"
    then builtins.toPath ("${toString path}/${x}.nix")
    else x;
in
rec {
  firstOrDefault = first: default: if !isNull first then first else default;

  existsOrDefault = x: set: default: if hasAttr x set then getAttr x set else default;

  # Derivation agnostic settings for all types of top level derivations (nixos, home-manager && darwin).
  mkUserHome = { config, system ? "x86_64-linux" }:
    { ... }: {
      imports = [
        (import ../home/modules)
        (import ../home/profiles)
        (import config)
      ];

      # For compatibility with nix-shell, nix-build, etc.
      home.file.".nixpkgs".source = inputs.nixpkgs;
      home.sessionVariables."NIX_PATH" =
        "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

      # Use the same Nix configuration for the user
      xdg.configFile."nixpkgs/config.nix".source = ../nix/config.nix;

      # Re-expose self and nixpkgs as flakes.
      xdg.configFile."nix/registry.json".text = builtins.toJSON {
        version = 2;
        flakes =
          let
            toInput = input:
              {
                type = "path";
                path = input.outPath;
              } // (
                filterAttrs
                  (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                  input
              );
          in
          [
            {
              from = { id = "nyx"; type = "indirect"; };
              to = toInput inputs.self;
            }
            {
              from = { id = "nixpkgs"; type = "indirect"; };
              to = toInput inputs.nixpkgs;
            }
          ];
      };

      # TODO: Note sure where this should go
      home.sessionPath = [ "$HOME/.local/nyx/bin" "$XDG_BIN_HOME" ];

      home.stateVersion = "20.09";
    };

  # Top level derivation for just home-manager
  mkHome = name: { config ? name, user ? "eden", system ? "x86_64-linux" }:
    let
      pkgs = inputs.self.pkgsBySystem."${system}";
      userConf = import (strToFile user ../user);
      username = userConf.name;
      homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    in
    nameValuePair name (
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = { inherit username homeDirectory; };

            imports =
              let
                userConf = strToFile config ../home/hosts;
                home = mkUserHome { inherit system; config = userConf; };
              in
              [ home ];

            xdg.configFile."nix/nix.conf".text =
              let
                nixConf = import ../nix/conf.nix;
              in
              ''
                extra-substituters = ${builtins.concatStringsSep " " nixConf.binaryCaches }
                extra-trusted-public-keys = ${builtins.concatStringsSep " " nixConf.binaryCachePublicKeys}
                experimental-features = nix-command flakes
              '';

            nixpkgs = {
              config = import ../nix/config.nix;
              overlays = inputs.self.overlays."${system}";
            };
          }
        ];
        extraSpecialArgs =
          let
            self = inputs.self;
            user = userConf;
          in
          { inherit inputs name self system user; };
      }
    );

  mkSystem = name: { config ? name, user ? "eden", system ? "x86_64-linux" }:
    nameValuePair name (
      let
        pkgs = inputs.self.pkgsBySystem."${system}";
        userConf = import (strToFile user ../user);
      in
      nixosSystem {
        inherit system;
        modules = [
          (
            { name, ... }: {
              networking.hostName = name;
            }
          )
          (
            { inputs, ... }: {
              # Use the nixpkgs from the flake.
              nixpkgs = { inherit pkgs; };

              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            }
          )
          (
            { pkgs, ... }: {
              # Don't rely on the configuration to enable a flake-compatible version of Nix.
              nix = {
                package = pkgs.nixFlakes;
                extraOptions = "experimental-features = nix-command flakes";
              };
            }
          )
          (
            { inputs, ... }: {
              # Re-expose self and nixpkgs as flakes.
              nix.registry = {
                self.flake = inputs.self;
                nixpkgs = {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  flake = inputs.nixpkgs;
                };
              };
            }
          )
          (
            { ... }: {
              system.stateVersion = "21.05";
            }
          )
          (inputs.home-manager.nixosModules.home-manager)
          (
            {
              home-manager = {
                # useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs =
                  let
                    self = inputs.self;
                    user = userConf;
                  in
                  # NOTE: Cannot pass name to home-manager as it passes `name` in to set the `hmModule`
                  { inherit inputs self system user; };
              };
            }
          )
          (import ../system/common/modules)
          (import ../system/common/profiles)
          (import ../system/nixos/modules)
          (import ../system/nixos/profiles)
          (import (strToPath config ../system/nixos/hosts))
        ];
        specialArgs =
          let
            self = inputs.self;
            user = userConf;
          in
          { inherit inputs name self system user; };
      }
    );

  mkDarwin = name: { config ? name, user ? "eden" }:
    nameValuePair name (
      let
        system = "x86_64-darwin";
        pkgs = inputs.self.pkgsBySystem."${system}";
        userConf = import (strToFile user ../user);
        nixConf = import ../nix/conf.nix;
      in
      inputs.darwin.lib.darwinSystem {
        inherit system;
        modules = [
          (
            { pkgs, ... }: {
              # Don't rely on the configuration to enable a flake-compatible version of Nix.
              nix = {
                inherit (nixConf) binaryCaches binaryCachePublicKeys;
                package = pkgs.nixFlakes;
                extraOptions = "experimental-features = nix-command flakes";
              };
              services.nix-daemon.enable = true;
              # users.nix.configureBuildUsers = true; # Not sure I am ready for this
            }
          )
          (inputs.home-manager.darwinModules.home-manager)
          (
            {
              home-manager = {
                # useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs =
                  let
                    self = inputs.self;
                    user = userConf;
                  in
                  # NOTE: Cannot pass name to home-manager as it passes `name` in to set the `hmModule`
                  { inherit inputs pkgs self system user; };
              };
            }
          )
          (
            { config, ... }: {
              system.activationScripts.applications.text = pkgs.lib.mkForce (
                ''
                    echo "setting up ~/Applications/Nix..."
                    rm -rf ~/Applications/Nix
                    mkdir -p ~/Applications/Nix
                    chown ${userConf.name} ~/Applications/Nix
                    find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
                      src="$(/usr/bin/stat -f%Y $f)"
                      appname="$(basename $src)"
                      osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/${userConf.name}/Applications/Nix/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
                  done
                ''
              );
            }
          )
          (import ../system/common/modules)
          (import ../system/common/profiles)
          (import ../system/darwin/modules)
          (import ../system/darwin/profiles)
          (import (strToPath config ../system/darwin/hosts))
        ];
        specialArgs =
          let
            self = inputs.self;
            user = userConf;
          in
          { inherit inputs name self system user pkgs; };
      }
    );
}
