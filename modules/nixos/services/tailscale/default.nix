{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.my.nixos.services.tailscale;
in {
  options.my.nixos.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale VPN service";

    authKeyFile = mkOption {
      description = "Key file to use for authentication";
      default = config.age.secrets.tailscaleAuthKey.path or null;
      type = types.nullOr types.path;
    };

    kind = mkOption {
      description = "Define type of node and enable required features";
      default = "both";
      type = types.enum ["none" "client" "server" "both"];
    };

    operator = mkOption {
      description = "Tailscale operator name";
      default = null;
      type = types.nullOr types.str;
    };

    exitnode = mkOption {
      description = "Advertize this node as an exit node";
      default = false;
      type = types.bool;
    };

    acceptRoutes = mkOption {
      description = "Accept routes from the Tailscale network";
      type = types.bool;
      default = false;
    };

    advertiseRoutes = mkOption {
      description = "Advertise routes to the Tailscale network ie. subnet routing";
      type = types.nullOr types.str;
      example = "192.168.1.0/24";
      default = null;
    };

    # advertiseTags = mkOption {
    #   description = "Advertise tags to the Tailscale network";
    #   type = types.list types.str;
    #   default = "tag:nixos";
    # };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.my.nixos.services.tailscale.authKeyFile != null;
        message = "config.tailscale.authKeyFile cannot be null.";
      }
    ];

    # Accept DNS from Tailscale (MagicDNS)
    services.resolved.enable = true;
    networking = {
      search = [config.my.snippets.tailnet.name];
      nameservers = [
        "100.100.100.100"
        "8.8.8.8"
        "1.1.1.1"
      ];
    };

    services.tailscale = {
      inherit (cfg) authKeyFile;
      enable = true;

      extraUpFlags =
        ["--ssh"]
        ++ lib.optional (cfg.operator != null) "--operator ${cfg.operator}";

      extraSetFlags =
        lib.optional cfg.exitnode "--advertise-exit-node"
        ++ lib.optional cfg.acceptRoutes "--accept-routes"
        # ++ lib.optional (cfg.advertiseTags) "--advertise-tags=${cfg.advertiseTags}"
        ++ lib.optional (cfg.advertiseRoutes != null) "--advertise-routes=${cfg.advertiseRoutes}";

      openFirewall = true;
      useRoutingFeatures = cfg.kind;
    };
  };
}
