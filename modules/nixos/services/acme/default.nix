{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.my.nixos.services.acme;
  caddy = config.my.nixos.services.caddy;
  domain = config.my.nixos.base.domain;
in {
  options.my.nixos.services.acme = {
    enable = mkOption {
      description = "Automatic Certificate Management Environment for TLS";
      type = types.bool;
      default = false;
    };

    credentials = lib.mkOption {
      description = "DNS credentials from provider";
      type = types.nullOr types.path;
      default = null;
    };
  };

  config = lib.mkIf (cfg.enable || caddy.enable) {
    assertions = [
      {
        assertion = domain != "";
        message = ''
          Base domain must be defined for acme.
          `config.my.nixos.base.domain`
        '';
      }
      {
        assertion = cfg.credentials != null;
        message = ''
          Missing credentials for DNS provider.
          `config.my.nixos.services.acme.credentials`
        '';
      }
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "edenofest@gmail.com";
      certs."${domain}" = {
        inherit domain;
        reloadServices = ["caddy.service"];
        extraDomainNames = ["*.${domain}"];
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;
        # group = config.services.caddy.group;
        environmentFile = cfg.credentials;
      };
    };
  };
}
