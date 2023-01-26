{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.vale;
in
{
  options.nyx.modules.shell.vale = {
    enable = mkEnableOption "vale configuration";
  };

  # TODO: Find how to sync external packages
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vale
    ];

    home.file = {
      ".config/vale" = {
        source = ../../../config/.config/vale;
        recursive = true;
      };
    };
  };
}
