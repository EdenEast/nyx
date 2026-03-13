{
  config,
  lib,
  ...
}: let
  cfg = config.my.nixos.services.tailscale;
in {
  options.my.nixos.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";

    authKeyFile = lib.mkOption {
      description = "Key file to use for authentication";
      default = config.age.secrets.tailscaleAuthKey.path or null;
      type = lib.types.nullOr lib.types.path;
    };

    operator = lib.mkOption {
      description = "Tailscale operator name";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.my.nixos.services.tailscale.authKeyFile != null;
        message = "config.tailscale.authKeyFile cannot be null.";
      }
    ];

    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    # Accept DNS from Tailscale (MagicDNS)
    services.resolved.enable = true;

    services.tailscale = {
      inherit (cfg) authKeyFile;
      enable = true;

      extraUpFlags =
        ["--ssh"]
        ++ lib.optional (cfg.operator != null) "--operator ${cfg.operator}";

      openFirewall = true;
      useRoutingFeatures = "both";
    };
  };
}
