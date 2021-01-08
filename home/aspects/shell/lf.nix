{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.shell.lf;
  additionalPkgs = with pkgs; [
    vimv # Batch rename files with vim
  ];
in {
  options.nyx.aspects.shell.lf = {
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
    xdg.configFile."lf".source = ../../files/.config/lf;
  };
}
