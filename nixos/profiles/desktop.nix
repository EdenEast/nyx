{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;
in
{
  options.nyx.profiles.desktop.enable = mkEnableOption "desktop profile";

  config = mkIf cfg.enable {
    fonts = {
      fonts = with pkgs; [
        (nerdfonts.override {
          fonts = [ "Hack" "Meslo" "UbuntuMono" ];
        })
      ];
    };

    services.xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    hardware = {
      pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };
    };

    nyx.modules = {
      caps.enable = true;
    };
  };
}
