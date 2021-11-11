{ lib, ... }:

with builtins;
with lib;
{
  imports = let
    files = filterAttrs (
      n: v: v != null && !(hasPrefix "_" n) && v == "regular" && n != "default.nix"
    ) (readDir ./.);
    paths = map (x: "${toString ./.}/${x}") (attrNames files);
  in
    paths;
}
