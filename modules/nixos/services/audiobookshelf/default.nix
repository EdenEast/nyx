{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.nixos.server) domain;
  cfg = config.my.nixos.services.audiobookshelf;
in {
  options.my.nixos.services.audiobookshelf = {
    enable = lib.mkEnableOption "Enable the audiobookshelf service";

    port = lib.mkOption {
      description = "The TCP port Audiobookshelf will listen on.";
      default = 8555;
      type = lib.types.port;
    };

    tailscale = {
      enable = lib.mkOption {
        description = "Enable tailscale service";
        default = config.services.tailscale.enable;
        type = lib.types.bool;
      };

      name = lib.mkOption {
        description = "Name of the audiobookshelf service";
        default = "audiobookshelf";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.my.nixos.services.audiobookshelf.enable {
    services = {
      audiobookshelf = {
        enable = true;
        inherit (cfg) port;
        openFirewall = true;
      };

      # TODO: https://github.com/tailscale/tailscale/issues/18381
      # tailscale.serve.services.${cfg.tailscale.name}.https."443" = "https://localhost:${toString cfg.port}";
    };

    systemd.services.audiobookshelf-tailscale-serve = lib.mkIf cfg.tailscale.enable {
      description = "Tailscale Service proxy for Audiobookshelf";
      wantedBy = ["multi-user.target"];
      after = [
        "audiobookshelf.service"
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

    services.caddy.virtualHosts."audiobookshelf.ts.${domain}" = lib.mkIf cfg.enable {
      useACMEHost = domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
