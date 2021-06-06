{ config, lib, ... }:

with lib;
let cfg = config.nyx.aspects.shell.keybase;
in {
  options.nyx.aspects.shell.keybase.enable =
    mkEnableOption "keybase/kbfs configuration";

  config = mkIf cfg.enable { services.kbfs.enable = true; };
}

