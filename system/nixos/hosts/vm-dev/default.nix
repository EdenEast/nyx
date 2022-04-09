{ ... }:

{
  imports = [ ./hardware.nix ];

  virtualisation.vmware.guest.enable = true;

  # Interface is this on Intel Fusion
  networking.interfaces.ens33.useDHCP = true;

  nyx = {
    modules = {
      user.home = ./home.nix;
      caps.enable = true;
      yubikey.enable = true;
    };
    profiles = {
      desktop.enable = true;
    };
  };
}
