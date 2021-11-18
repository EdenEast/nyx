{ lib, ... }:

with builtins;
with lib;
{
  imports =
    let
      paths = filterAttrs (n: v: v != null && !(hasPrefix "_" n)) (readDir ./.);
      files = filterAttrs (n: v: v == "regular" && n != "default.nix") paths;
      dirs = filterAttrs (n: v: v == "directory") paths;
      map' = p: map (x: "${toString ./.}/${x}") (attrNames p);
    in
    map' dirs ++ map' files;
}
