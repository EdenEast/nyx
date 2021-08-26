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

    services.xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;

      displayManager = {
        lightdm.enable = true;
        session = [
          {
            name = "home-manager";
            manage = "window";
            start = ''
              ${pkgs.runtimeShell} $HOME/.hm-xsession &
              waitPID=$!
            '';
          }
        ];
      };
    };

    sound.enable = true;
    environment.systemPackages = with pkgs; [
      pamixer
    ];

    hardware = {
      pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };
    };


    services.printing.enable = true;

    nyx.modules = {
      caps.enable = true;
    };
  };
}
