{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  inherit (config.my.nixos.server) domain;
  cfg = config.my.nixos.services.caddy;
in {
  options.my.nixos.services.caddy = {
    enable = mkOption {
      description = "Caddy reverse proxy";
      type = types.bool;
      default = false;
    };

    credentials = lib.mkOption {
      description = "DNS credentials from provider";
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = domain != "";
        message = ''
          Base domain must be defined for caddy.
          `config.my.nixos.server.domain`
        '';
      }
      {
        assertion = cfg.credentials != null;
        message = ''
          Missing credentials for DNS provider.
          `config.my.nixos.services.caddy.credentials`
        '';
      }
    ];

    # TODO: https://github.com/tailscale/tailscale/issues/7650
    # There currently is an issue with now CNAME's are resolved on some operating system (everything other than mac and
    # ios). This caused the name server to be tailscale's instead of cloudflare and failing to get the certs. To solve
    # this issue I have to point cloudflare DNS record to an A record pointing to the tailscale ip address of the server
    security.acme = {
      acceptTerms = true;
      defaults.email = "edenofest@gmail.com";
      certs."${domain}" = {
        inherit domain;
        inherit (config.services.caddy) group;

        reloadServices = ["caddy.service"];
        extraDomainNames = ["*.${domain}" "*.ts.${domain}"];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        environmentFile = cfg.credentials;
      };
    };

    services.caddy.enable = true;
  };
}
