{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.nixos) server;
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

    sshPort = lib.mkOption {
      description = "The TCP port forgejo's built-in SSH server will listen on.";
      default = 2222;
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
        package = pkgs.forgejo; # Use the non lts version of forgejo
        settings.server = {
          ROOT_URL = "https://${domain}";
          PROTOCOL = "http";
          DOMAIN = domain;
          HTTP_PORT = cfg.port;
          START_SSH_SERVER = true;
          SSH_LISTEN_PORT = cfg.sshPort;
          SSH_PORT = cfg.sshPort;
          SSH_DOMAIN = "thor.${config.my.snippets.tailnet.name}";
          SSH_USER = config.services.forgejo.user;
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

    networking.firewall.allowedTCPPorts = [cfg.sshPort];
  };
}
