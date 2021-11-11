{ lib, ... }:

with builtins;
with lib;
{
  imports = let
    dirs = filterAttrs (
      n: v: v != null && !(hasPrefix "_" n) && (v == "directory")
    ) (readDir ./.);
    paths = map (x: "${toString ./.}/${x}") (attrNames dirs);
  in
    paths;
}

# { ... }:

# {
#   imports = [
#     ./caps.nix
#     ./disk.nix
#     ./nvidia.nix
#     ./user.nix
#     ./yubikey.nix
#   ];
# }
