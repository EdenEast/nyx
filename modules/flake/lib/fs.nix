# File system utilities for working with directories and files in Nix.
# Provides functions to scan directories, import modules, and filter entries based on naming conventions.
#
# Naming conventions:
#   - scan*  | filesystem scan only, returns paths only (no imports/evaluations).
#   - import* | imports and evaluates files with proveded arguments.
#
# Conventions:
#   - Entries starting with '_' are ignored (not importable).
#   - Directories are importable if they contain a default.nix file.
#   - Regular files are importable if they have a .nix extension and don't start
{lib}: let
  # Common filter predicate for importable entries.
  # Excludes entries starting with '_' and non-.nix files (except directories).
  isImportable = name: type:
    !(lib.strings.hasPrefix "_" name)
    && ((type == "directory") || ((name != "default.nix") && (lib.strings.hasSuffix ".nix" name)));

  # Convert a filename to an attribute name by removing the .nix extension if it's a regular file.
  toAttrName = name:
    if lib.strings.hasSuffix ".nix" name
    then lib.removeSuffix ".nix" name
    else name;
in rec {
  # Scan a directory and return paths to all importable modules
  #
  # Returns paths to:
  #   - All directories that contain a default.nix file
  #   - All .nix files that don't start with "default"
  #
  # All entries starting with '_' are ignored.
  #
  # Usage:
  #   imports = scanPaths ./modules;
  #   # Returns: [ "./modules/foo" "./modules/bar.nix" "./modules/baz.nix" ... ]
  scanPaths = path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs isImportable (builtins.readDir path)
      )
    );

  # Scan a directory and return just filename (not full paths)
  #
  # All entries starting with '_' are ignored.
  #
  # Usage:
  #   imports = scanPaths ./modules;
  #   # Returns: [ "foo" "bar.nix" "baz.nix" ... ]
  scanNames = path:
    builtins.attrNames (
      lib.attrsets.filterAttrs isImportable (builtins.readDir path)
    );

  # Scan directory and return attrset of paths
  # Keys are the filename without .nix extension or directories
  #
  # Usage:
  #   modules = sscanAttrs ./.;
  #   # Returns: { foo = ./foo; bar = ./bar.nix; baz = ./baz.nix; ... }
  scanAttrs = path: let
    entries = lib.attrsets.filterAttrs isImportable (builtins.readDir path);
  in
    lib.mapAttrs' (name: _type: {
      name = toAttrName name;
      value = path + "/${name}";
    })
    entries;

  # Scan directory, import all modules, and merge their attrsets.
  #
  # Useful when importing a directory that has multiple files exporting attrsets that need to be
  # merged together. For example, a directory of modules where each file exports a set of modules.
  #
  # Usage:
  #   allPackages = importAndMarge ./packages { inherit inputs self; };
  importAndMarge = path: args: let
    files = builtins.attrNames (lib.attrsets.filterAttrs isImportable (builtins.readDir path));
    imported = builtins.map (f: import (path + "/${f}") args) files;
  in
    lib.foldl' lib.recursiveUpdate {} imported;

  # Import all files and return an attrset of evaluated results.
  # Keys are the filename without .nix extension (if it's a regular file) or the directory name (if it's a directory).
  # Each file is imported with the provided arguments.
  #
  # Usage:
  #   modules = importAttrs ./modules { inherit inputs self; };
  #   # Returns: { foo = <evaluated>; bar = <evaluated>; baz = <evaluated>; ... }
  importAttrs = path: args: let
    entries = lib.attrsets.filterAttrs isImportable (builtins.readDir path);
  in
    lib.mapAttrs' (name: _type: {
      name = toAttrName name;
      value = import (path + "/${name}") args;
    })
    entries;

  # Apply function fn to the result of (lib.fs.importAttrs path args)
  #
  # Usage:
  #   modules = importMapAttrs ./modules { inherit inputs self; } (name: value: value // {...});
  #   # Returns: { foo = <evaluated>; bar = <evaluated>; baz = <evaluated>; ... }
  importMapAttrs = path: args: fn: lib.mapAttrs (name: value: fn name value) (importAttrs path args);
}
