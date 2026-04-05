{
  config,
  lib,
  ...
}: let
  cfg = config.my.nixos.services.syncthing;
in {
  options.my.nixos.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing file syncing service";

    dataDir = lib.mkOption {
      description = "The path where synchronised directories will exist";
      type = lib.types.path;
      default =
        if cfg.user
        then "/home/${cfg.user}"
        else "/var/lib/syncthing";
    };

    user = lib.mkOption {
      description = "User to run Syncthing as.";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      inherit (cfg) dataDir; # TODO: If user is defined I need to also define keys and creds
      enable = true;
      openDefaultPorts = true;
    };
  };
}
