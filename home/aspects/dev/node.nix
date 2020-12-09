{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.dev.node;
  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
  cacheHome = config.xdg.cacheHome;
in {
  options.nyx.aspects.dev.node = {

    enable = mkEnableOption "node configuration";

    registry = mkOption {
      type = types.str;
      default = "https://registry.npmjs.org/";
      description = "Registry to use for npm";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nodejs yarn ];

    home.sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${configHome}/npm/config";
      NPM_CONFIG_CACHE = "${configHome}/npm";
      PM_CONFIG_TMP = "${cacheHome}/tmp/npm";
      NPM_CONFIG_PREFIX = "${dataHome}/npm";
      NODE_REPL_HISTORY = "${cacheHome}/node/repl_history";
    };

    xdg.configFile."npm/config".text = ''
      cache=${cacheHome}/npm
      prefix=${dataHome}/npm
      registry=${cfg.registry}
    '';

    # npm and yarn will install into this location
    home.sessionPath = [ "${dataHome}/npm/bin" ];
  };
}
