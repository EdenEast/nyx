{ lib, inputs, ... }:

with inputs.nixpkgs.lib;
{
  # Creates a host configuration that can them be used by either the mkHomeConfiguration, or mkSystemConfiguration
  # functions. These are internal abstractions.
  mkHostConfig = name: { system, config }:
    lib.nameValuePair name ({ ... }: {
      imports = [
        (import ../home/modules)
        (import ../home/profiles)
        (config)
      ];

      # Reexpose self and nixpkgs as a flake
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
              from = { id = "self"; type = "indirect"; };
              to = toInput inputs.self;
            }
            {
              from = { id = "nixpkgs"; type = "indirect"; };
              to = toInput inputs.nixpkgs;
            }
          ];
      };
    });
}
