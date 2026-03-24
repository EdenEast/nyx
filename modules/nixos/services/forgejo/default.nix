{
  config,
  lib,
  pkgs,
  ...
}: let
  server = config.my.nixos.server;
  domain = "git.ts.${server.domain}";
  cfg = config.my.nixos.services.forgejo;
in {
  options.my.nixos.services.forgejo = {
    enable = lib.mkEnableOption "Enable the forgejo service";

    port = lib.mkOption {
      description = "The TCP port forgejo will listen on.";
      default = 3306;
      type = lib.types.port;
    };

    tailscale = {
      enable = lib.mkOption {
        description = "Enable tailscale service";
        default = config.services.tailscale.enable;
        type = lib.types.bool;
      };

      name = lib.mkOption {
        description = "Name of the forgejo service";
        default = "git";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.my.nixos.services.forgejo.enable {
    services = {
      forgejo = {
        enable = true;
        settings.server = {
          ROOT_URL = "https://${domain}";
          PROTOCAL = "https";
          DOMAIN = domain;
          HTTP_PORT = cfg.port;
        };
      };
    };

    systemd.services.forgejo-tailscale-serve = lib.mkIf cfg.tailscale.enable {
      description = "Tailscale Service proxy for forgejo";
      wantedBy = ["multi-user.target"];
      after = [
        "forgejo.service"
        "tailscaled.service"
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = lib.strings.concatStringsSep " " [
          "${pkgs.tailscale}/bin/tailscale serve"
          "--service=svc:${cfg.tailscale.name}"
          "--https=443"
          "http://localhost:${toString cfg.port}"
        ];
        ExecStop = "${pkgs.tailscale}/bin/tailscale serve clear svc:${cfg.tailscale.name}";
      };
    };

    services.caddy.virtualHosts."${domain}" = lib.mkIf cfg.enable {
      useACMEHost = server.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
