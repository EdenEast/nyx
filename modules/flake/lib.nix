{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.lib =
    rec {
      # pruneAttr recursively removes attributes with null values from a set.
      # It traverses nested attribute sets, returning a set with all nulls pruned.
      # Usage: pruneAttr { a = null; b = { c = null; d = 1; }; } => { b = { d = 1; }; }
      pruneAttrs = attrs:
        lib.filterAttrs (_: v: v != null) (
          lib.mapAttrs (
            _: v:
              if builtins.isAttrs v
              then pruneAttrs v
              else v
          )
          attrs
        );

      # Given a directory path, returns an attribute set mapping names to either directories or .nix files within
      # that directory. Nix files take precidence over directories. Entries starting with '_' are ignored.
      #
      # Example:
      #
      # importDir = path: fn: {
      #   <name> = {
      #     path = <absolute path to directory or nix file>;
      #     type = "directory" | "regular";
      #   };
      #   ...
      # }
      importDir = path: fn: let
        entries = lib.filterAttrs (name: _type: !lib.hasPrefix "_" name) (builtins.readDir path);

        dirPaths = lib.pipe entries [
          (lib.filterAttrs (_name: type: type == "directory"))
          (lib.mapAttrs (name: type: {
            path = path + "/${name}";
            inherit type;
          }))
        ];

        nixPaths = lib.pipe entries [
          (lib.filterAttrs (name: type: type != "directory" && lib.hasSuffix ".nix" name))
          (lib.mapAttrs' (name: type: {
            name = lib.removeSuffix ".nix" name;
            value = {
              path = path + "/${name}";
              inherit type;
            };
          }))
        ];

        combined = dirPaths // nixPaths;
      in
        lib.optionalAttrs (builtins.pathExists path) (fn combined);

      mapDir = path: fn: importDir path (entries: lib.mapAttrs fn entries);

      importsAllNixFiles = path:
        importDir path (
          entries:
            lib.pipe entries [
              (lib.filterAttrs (
                name: value:
                  if value.type == "regular"
                  then name != "default"
                  else true
              ))
              (lib.mapAttrs (_: value: value.path))
              builtins.attrValues
            ]
        );
    }
    // lib;
}
