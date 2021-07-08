{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.dev.node;

  boolToString = v: if v then "true" else "false";

  configHome = config.xdg.configHome;
  dataHome = config.xdg.dataHome;
  cacheHome = config.xdg.cacheHome;
in
{
  options.nyx.modules.dev.node = {

    enable = mkEnableOption "node configuration";

    registry = mkOption {
      type = types.str;
      default = "https://registry.npmjs.org/";
      description = "Registry to use for npm";
    };

    strictSsl = mkOption {
      type = with types; nullOr bool;
      default = null;
      description =
        "Use SSL key validation when making requests to registry via https";
    };

    httpProxy = mkOption {
      type = types.str;
      default = "";
      description = "Http proxy";
    };

    httpsProxy = mkOption {
      type = types.str;
      default = "";
      description = "Https proxy";
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
      ${optionalString (cfg.strictSsl != null)
      "strict-ssl=${boolToString cfg.strictSsl}"}
      ${optionalString (cfg.httpProxy != "") "proxy=${cfg.httpProxy}"}
      ${optionalString (cfg.httpsProxy != "") "https-proxy=${cfg.httpsProxy}"}
    '';

    # npm and yarn will install into this location
    home.sessionPath = [ "${dataHome}/npm/bin" ];
  };
}
