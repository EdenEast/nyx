{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    # https://github.com/nixos/nixos-hardware/tree/master/framework/13-inch/7040-amd
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # As of firmware v03.03, a bug in the EC causes the system to wake if AC is connected despite the lid being closed.
  # A workaround has been upstreamed in Linux v6.7. For older kernels, the following works around this, with the
  # trade-off that keyboard presses also no longer wake the system.
  hardware.framework.amd-7040.preventWakeOnAC = true;

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
