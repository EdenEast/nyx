{ inputs, pkgs, config, ... }:

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

  # The firmware on the fingerprint sensor needs a downgrade to make it work on Linux. The process is documented here.
  # However on recent NixOS versions also fwupd can no longer update the firmware. Using the following snippet allows
  # to temporarly downgrade fwupd to an old-enough version:
  services.fwupd = {
    enable = true;

    # we need fwupd 1.9.7 to downgrade the fingerprint sensor firmware
    package = (import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/bb2009ca185d97813e75736c2b8d1d8bb81bde05.tar.gz";
        sha256 = "sha256:003qcrsq5g5lggfrpq31gcvj82lb065xvr7bpfa8ddsw8x4dnysk";
      })
      {
        inherit (pkgs) system;
      }).fwupd;
  };

  environment.systemPackages = with pkgs; [
    libnotify
    kitty
    lutris
  ];

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
}
