{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.nixos.services.searxng;
  tailnet = config.my.snippets.tailnet;
in {
  options.my.nixos.services.searxng = {
    enable = lib.mkEnableOption "Enable the searxng service";

    port = lib.mkOption {
      description = "The TCP port searxng will listen on.";
      default = 8080;
      type = lib.types.port;
    };

    tailscale = {
      enable = lib.mkOption {
        description = "Enable tailscale service";
        default = config.services.tailscale.enable;
        type = lib.types.bool;
      };

      name = lib.mkOption {
        description = "Name of the searxng service";
        default = "search";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf config.my.nixos.services.searxng.enable {
    services.searx = {
      enable = true;
      package = pkgs.searxng;

      settings = {
        use_default_settings = true;

        server = {
          inherit (cfg) port;
          base_url = "https://${cfg.tailscale.name}.${tailnet.name}";
          secret_key = "@SEARX_SECRET_KEY@";
        };
      };
    };

    systemd.services.searxng-tailscale-serve = lib.mkIf cfg.tailscale.enable {
      description = "Tailscale Service proxy for searxng";
      wantedBy = ["multi-user.target"];
      after = [
        "searx.service"
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
  };
}
