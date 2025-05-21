self: system:
with self.lib; let
  pkgs = self.legacyPackages."${system}";
  dirs =
    filterAttrs
    (
      n: v: v != null && !(hasPrefix "_" n) && (v == "directory")
    )
    (builtins.readDir ./.);
  paths = mapAttrs (name: _value: "${toString ./.}/${name}") dirs;
  result = mapAttrs (_name: value: pkgs.callPackage value {}) paths;
in
  result
