{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;
in
{
  options.nyx.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
  };

  config = mkIf cfg.enable {
    fonts = {
      fonts = with pkgs; [
        (
          nerdfonts.override {
            fonts = [ "Hack" "Meslo" "UbuntuMono" ];
          }
        )
      ];
    };
  };
}
