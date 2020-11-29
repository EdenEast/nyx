{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.node;
in {
  options.nyx.aspects.node.enable = mkEnableOption "node configuration";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nodejs yarn ];

    home.sessionVariables = {
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      NPM_CONFIG_CACHE = "$XDG_CACHE_HOME/npm";
      PM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
      NPM_CONFIG_PREFIX = "$XDG_CACHE_HOME/npm";
      NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node/repl_history";
    };

    xdg.configFile."npm/config".text = ''
      cache=$XDG_CACHE_HOME/npm
      prefix=$XDG_DATA_HOME/npm
    '';

    home.sessionPath = [ "$(yarn global bin)" ];
  };
}
