{
  config,
  lib,
  ...
}: let
  inherit (config.my.nixos) server;
  cfg = config.my.nixos.services.send;
in {
  options.my.nixos.services.send = {
    enable = lib.mkEnableOption "Enable the send service";

    port = lib.mkOption {
      description = "The TCP port send will listen on.";
      default = 1443;
      type = lib.types.port;
    };

    tailscale = {
      enable = lib.mkOption {
        description = "Enable tailscale service";
        default = config.services.tailscale.enable;
        type = lib.types.bool;
      };

      name = lib.mkOption {
        description = "Name of the send service";
        default = "send";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.my.nixos.services.send.enable {
    services.send = {
      inherit (cfg) port;
      enable = true;
    };

    my.nixos.services.cloudflared.ingress = {
      "${cfg.tailscale.name}.${server.domain}" = "http://127.0.0.1:${toString cfg.port}";
    };
  };
}
