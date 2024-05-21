self: pkgs:

with self.lib;
let
  dirs = filterAttrs
    (
      n: v: v != null && !(hasPrefix "_" n) && (v == "directory")
    )
    (builtins.readDir ./.);
  paths = mapAttrs (name: value: "${toString ./.}/${name}") dirs;
  result = mapAttrs (name: value: pkgs.callPackage value { }) paths;
in
result
