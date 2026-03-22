{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.my.nixos.services.golink;
in {
  options.my.nixos.services.golink = {
    enable = lib.mkEnableOption "golink, go/ links for Tailscale";

    authKeyFile = mkOption {
      description = "Key file to use for authentication";
      default = config.age.secrets.golinkAuthKey.path or null;
      type = types.nullOr types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.tailscale.enable;
        message = "Tailscale services must be enabled for golink";
      }
      {
        assertion = config.my.nixos.services.golink.authKeyFile != null;
        message = "config.my.nixos.services.golink.authKeyFile cannot be null.";
      }
    ];

    services.golink = {
      enable = true;
      tailscaleAuthKeyFile = cfg.authKeyFile;
    };
  };
}
