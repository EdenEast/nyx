{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.my.nixos.services.caddy;
  domain = config.my.nixos.base.domain;
in {
  options.my.nixos.services.caddy = {
    enable = mkOption {
      description = "Caddy reverse proxy";
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = domain != "";
        message = ''
          Base domain must be defined for caddy.
          `config.my.nixos.base.domain`
        '';
      }
    ];

    services.caddy = {
      enable = true;
      globalConfig = ''
        auto_https off
      '';
    };
  };
}
