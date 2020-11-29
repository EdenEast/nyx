{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.gnupg;
in {
  options.nyx.aspects.gnupg = {
    enable = mkEnableOption "gnupg configuration";
  };

  config = mkIf cfg.enable {
    programs.gpg = { enable = true; };

    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableScDaemon = true;
      enableSshSupport = true;
      verbose = true;
    };
  };
}
