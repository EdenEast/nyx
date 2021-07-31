{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.lf;
  additionalPkgs = with pkgs;
    [
      vimv # Batch rename files with vim
      ueberzug
    ];
in
{
  options.nyx.modules.shell.lf = {
    enable = mkEnableOption "lf configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.lf;
      defaultText = literalExample "pkgs.lf";
      description = "Lf Package to install.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ additionalPkgs;
    xdg.configFile."lf" = {
      source = ../../../config/.config/lf;
      executable = true;
      recursive = true;
    };
  };
}
