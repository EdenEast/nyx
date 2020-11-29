{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.gnupg;
in {
  options.nyx.aspects.shell.gnupg = {
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
