{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.profiles.desktop;
in
{
  options.nyx.profiles.desktop = { enable = mkEnableOption "desktop profile"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      synergy
    ];
    nyx.modules = {
      app.alacritty.enable = true;
      app.discord.enable = true;
      app.wezterm.enable = true;
    };
  };
}
