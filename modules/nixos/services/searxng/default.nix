{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.nixos.services.searxng;
  inherit (config.my.nixos) server;
  inherit (config.my.snippets) tailnet;
in {
  options.my.nixos.services.searxng = {
    enable = lib.mkEnableOption "Enable the searxng service";

    port = lib.mkOption {
      description = "The TCP port searxng will listen on.";
      default = 8088;
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

        search = {
          autocomplete = "duckduckgo"; # dbpedia, duckduckgo, google, startpage, swisscows, qwant, wikipedia - leave blank to turn off
        };
        engines = [
          {
            name = "bing";
            disabled = true;
          }
          {
            name = "brave";
            disabled = true;
          }
        ];

        server = {
          inherit (cfg) port;
          base_url = "https://${cfg.tailscale.name}.${tailnet.name}";
          secret_key = "@SEARX_SECRET_KEY@";
          default_http_headers = {
            X-Content-Type-Options = "nosniff";
            X-XSS-Protection = "1; mode=block";
            X-Download-Options = "noopen";
            X-Robots-Tag = "noindex, nofollow";
            Referrer-Policy = "no-referrer";
          };
        };
        outgoing = {
          request_timeout = 5.0; # default timeout in seconds, can be override by engine
          max_request_timeout = 15.0; # the maximum timeout in seconds
          pool_connections = 100; # Maximum number of allowable connections, or null
          pool_maxsize = 10; # Number of allowable keep-alive connections, or null
          enable_http2 = true; # See https://www.python-httpx.org/http2/
        };
      };
    };

    systemd.services.searx-tailscale-serve = lib.mkIf cfg.tailscale.enable {
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

    services.caddy.virtualHosts."${cfg.tailscale.name}.ts.${server.domain}" = lib.mkIf cfg.enable {
      useACMEHost = server.domain;
      extraConfig = ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };
  };
}
