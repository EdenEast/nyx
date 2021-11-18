{ config, pkgs, modulesPath, ... }:

{
  imports = [ ./hardware.nix ];

  networking.enableIPv6 = true;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  nix.modules = {
    user.home = ./home.nix;
    caps.enable = true;
    yubikey.enable = true;
  };

  services.printing.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    displayManager.lightdm.enable = true;
  };

  fonts = {
    fonts = with pkgs; [
      (
        nerdfonts.override {
          fonts = [ "Hack" "Meslo" "UbuntuMono" ];
        }
      )
    ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };
  };
}
