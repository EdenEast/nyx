{
  config,
  lib,
  ...
}: let
  inherit (lib) types;
  cfg = config.my.nixos.services.cloudflared;
in {
  options.my.nixos.services.cloudflared = {
    enable = lib.mkEnableOption "cloudflared tunnel service";
    tunnelId = lib.mkOption {
      type = types.str;
      default = "";
      description = "The Cloudflare tunnel ID";
    };
    credentialsFile = lib.mkOption {
      type = types.str;
      default = "";
      description = "Path to the tunnel credentials file.";
    };

    defaultRoute = lib.mkOption {
      type = types.str;
      default = "http_status:404";
      description = "Default route for unmatched requests.";
    };

    ingress = lib.mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Ingress rules";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels.${cfg.tunnelId} = {
        inherit (cfg) credentialsFile ingress;
        default = cfg.defaultRoute;
      };
    };
  };
}
