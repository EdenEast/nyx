{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.enableIPv6 = true;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  nyx = {
    modules = {
      user.home = ./home.nix;
      caps.enable = true;
      yubikey.enable = true;
    };

    profiles = {
      desktop = {
        enable = true;
        laptop = true;
      };
    };
  };
}
