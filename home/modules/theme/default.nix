{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.theme;
in
{
  options.nyx.modules.theme = {
    colors = mkOption {
      # type = with types; attrsOf str;
      type = with types; attrs;
      description = "Base16 colors";
    };
  };
}
