{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.lib = rec {
    # The `fs` attribute provides file system utilities, imported from a separate module.
    fs = import ./fs.nix {inherit lib;};

    # The `pruneAttrs` function recursively removes attributes with null values from a set.
    # It traverses nested attribute sets, returning a set with all nulls pruned.
    # Usage: pruneAttrs { a = null; b = { c = null; d = 1; }; } => { b = { d = 1; }; }
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
  };
}
