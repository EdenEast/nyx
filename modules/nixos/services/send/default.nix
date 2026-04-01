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

    # systemd.services.send-tailscale-serve = lib.mkIf cfg.tailscale.enable {
    #   description = "Tailscale Service proxy for send";
    #   wantedBy = ["multi-user.target"];
    #   after = [
    #     "send.service"
    #     "tailscaled.service"
    #   ];
    #
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #
    #     ExecStart = lib.strings.concatStringsSep " " [
    #       "${pkgs.tailscale}/bin/tailscale serve"
    #       "--service=svc:${cfg.tailscale.name}"
    #       "--https=443"
    #       "http://localhost:${toString cfg.port}"
    #     ];
    #     ExecStop = "${pkgs.tailscale}/bin/tailscale serve clear svc:${cfg.tailscale.name}";
    #   };
    # };
    #
    # services.caddy.virtualHosts."${cfg.tailscale.name}.ts.${server.domain}" = lib.mkIf cfg.enable {
    #   useACMEHost = server.domain;
    #   extraConfig = ''
    #     reverse_proxy http://127.0.0.1:${toString cfg.port}
    #   '';
    # };

    # services.caddy.virtualHosts."${cfg.tailscale.name}.${server.domain}" = {
    #   useACMEHost = server.domain;
    #   extraConfig = ''
    #     reverse_proxy http://127.0.0.1:${toString cfg.port}
    #   '';
    # };

    my.nixos.services.cloudflared.ingress = {
      "${cfg.tailscale.name}.${server.domain}" = "http://127.0.0.1:${toString cfg.port}";
    };
  };
}
