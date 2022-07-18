{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.theme;
in
{
  options.nyx.modules.theme = {
    name = mkOption {
      type = types.str;
      description = "Name of the theme loaded into color attributes";
      default = "nightfox";
    };
    colors = mkOption {
      type = types.attrs;
      description = "Color attributes";
      internal = true;
    };
  };

  config = {
    nyx.modules.theme.colors = with builtins; fromJSON (readFile ((toString ./.) + "/${cfg.name}.json"));
  };
}

# Default mouse acceleration
# defaults read .GlobalPreferences com.apple.mouse.scaling
# Result: 0.875
#
# Disable mouse acceleration
# defaults write .GlobalPreferences com.apple.mouse.scaling 0
