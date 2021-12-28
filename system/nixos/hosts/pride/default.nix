{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.interfaces.wlp3s0.useDHCP = true;

  nyx = {
    modules = {
      user.home = ./home.nix;

      bluetooth.enable = true;
      caps.enable = true;
      nvidia = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      yubikey.enable = true;
    };

    profiles = {
      desktop = {
        enable = true;
        laptop = true;
      };
    };
  };

  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;
}
