# Currently not being used and needs to be refactored
{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;
in
{
  # Enable and common options are defined in ../../common/profiles/desktop.nix
  # options.nyx.profiles.desktop = { };
  config = mkIf cfg.enable {
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
      disk.enable = true;
    };

  };
}
