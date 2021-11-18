{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  networking.interfaces.wlp3s0.useDHCP = true;

  nyx.modules = {
    user.home = ./home.nix;

    caps.enable = true;
    nvidia = {
      enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
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

  # programs.steam.enable = true;
}
