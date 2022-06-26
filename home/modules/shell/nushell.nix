{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nyx.modules.shell.nushell;
in
{
  options.nyx.modules.shell.nushell = {
    enable = mkEnableOption "neovim configuration";
    package = mkOption {
      description = "Package for nushell";
      type = with types; nullOr package;
      default = pkgs.nushell;
    };
  };
  config = mkIf cfg.enable {
    home.packages = mkIf (cfg.package != null) [ cfg.package ];

    xdg.configFile."nushell" = {
      source = ../../../config/.config/nushell;
      executable = true;
      recursive = true;
    };

  };
}
