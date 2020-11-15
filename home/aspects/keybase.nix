{ config, lib, ... }:

with lib;
let
  cfg = config.nyx.aspects.keybase;
in
{
  options.nyx.aspects.keybase.enable = mkEnableOption "keybase/kbfs configuration";

  config = mkIf cfg.enable {
    services.kbfs.enable = true;
  };
}

