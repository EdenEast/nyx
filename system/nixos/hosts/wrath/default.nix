{ pkgs, ... }:

{
imports = [ ./hardware.nix ];

  # networking.interfaces.wlp3s0.useDHCP = true;

  nyx = {
    modules = {
      user.home = ./home.nix;

      bluetooth.enable = true;
      caps.enable = true;
      yubikey.enable = true;
    };

    profiles = {
      desktop = {
        enable = true;
        laptop = true;
        flavor = "gnome";
      };
    };
  };

  hardware.keyboard.qmk.enable = true;

  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;
  environment.systemPackages = with pkgs; [
    lutris
  ];
}
