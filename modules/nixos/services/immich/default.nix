{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.nixos.services.immich;
  inherit (config.my.nixos) server;
in {
  options.my.nixos.services.immich = {
    enable = lib.mkEnableOption "Self-hosted photo and video management solution";

    port = lib.mkOption {
      description = "The TCP port Immich will listen on.";
      default = 2283;
      type = lib.types.port;
    };

    url = lib.mkOption {
      type = lib.types.str;
      default = "photos.ts.${server.domain}";
    };

    mediaDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };

    tailscale = {
      enable = lib.mkOption {
        description = "Enable tailscale service";
        default = config.services.tailscale.enable;
        type = lib.types.bool;
      };

      name = lib.mkOption {
        description = "Name of the immich service";
        default = "photos";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      inherit (cfg) port;
      openFirewall = true;
      mediaLocation = lib.mkIf (cfg.mediaDir != null) cfg.mediaDir;
    };

    # systemd.tmpfiles.rules = lib.mkIf (cfg.mediaDir != null) ["d ${cfg.mediaDir} 0775 immich ${cfg.group} - -"];
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];

    systemd.services.immich-tailscale-serve = lib.mkIf cfg.tailscale.enable {
      description = "Tailscale Service proxy for immich";
      wantedBy = ["multi-user.target"];
      after = [
        "immich-server.service"
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
