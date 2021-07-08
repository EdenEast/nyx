{ config, lib, ... }:

with lib;
let cfg = config.nyx.modules.shell.keybase;
in
{
  options.nyx.modules.shell.keybase.enable =
    mkEnableOption "keybase/kbfs configuration";

  config = mkIf cfg.enable { services.kbfs.enable = true; };
}

