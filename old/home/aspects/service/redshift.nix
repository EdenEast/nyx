{ config, lib, ... }:

with lib;
let cfg = config.nyx.aspects.service.redshift;
in {
  options.nyx.aspects.service.redshift.enable =
    mkEnableOption "redshift configuration";

  config = mkIf cfg.enable {
    services.redshift = {
      enable = true;
      latitude = "43.68066";
      longitude = "-79.61286";
      temperature = {
        day = 5500;
        night = 4800;
      };
    };
  };
}

