{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.nixos) server;
  cfg = config.my.nixos.services.paperless;
in {
  options.my.nixos.services.paperless = {
    enable = lib.mkEnableOption "Paperless service";

    mediaDir = lib.mkOption {
      description = "Directory to store the Paperless document";
      type = lib.types.str;
      default = "";
    };

    consumptionDir = lib.mkOption {
      description = "Directory to import new documents";
      type = lib.types.str;
      default = "";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
    };

    tailscale = {
      enable = lib.mkOption {
        description = "Enable tailscale service";
        type = lib.types.bool;
        default = config.services.tailscale.enable;
      };

      name = lib.mkOption {
        description = "Name of the immich service";
        type = lib.types.str;
        default = "photos";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.paperless = {
      enable = true;
      mediaDir = lib.mkIf (cfg.mediaDir != "") cfg.mediaDir;
      consumptionDir = lib.mkIf (cfg.consumptionDir != "") cfg.consumptionDir;
      consumptionDirIsPublic = true;

      settings = {
        PAPERLESS_URL = "";
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
        ];
      };
    };

    systemd.services.immich-tailscale-serve = lib.mkIf cfg.tailscale.enable {
      description = "Tailscale Service proxy for immich";
      wantedBy = ["multi-user.target"];
      after = [
        "immich.service"
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

    services.caddy.virtualHosts."${cfg.url}" = {
      useACMEHost = server.domain;
      extraConfig = ''
        reverse_proxy http://${config.services.immich.host}:${toString config.services.immich.port}
      '';
    };
  };
}
