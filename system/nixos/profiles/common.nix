{ config, inputs, lib, pkgs, ... }:

with lib;
let
  nixConf = import ../../../nix/conf.nix;
in
{
  config = {
    boot = {
      # Enable running aarch64 binaries using qemu.
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      # Clean temporary directory on boot.
      cleanTmpDir = true;

      # Enable support for nfs and ntfs.
      supportedFilesystems = [ "cifs" "ntfs" "nfs" ];
    };

    # This is deprecated. Use `networking.interface.<name>.useDHCP`
    networking.useDHCP = false;
    networking.networkmanager.enable = true;

    nix = {
      inherit (nixConf) binaryCaches binaryCachePublicKeys;

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      allowedUsers = [ "root" ];
    };

    time.timeZone = "America/Toronto";
    i18n.defaultLocale = "en_US.UTF-8";

    services = {
      cron.enable = true;
      locate.enable = true;
    };

    # List of bare minimal requirements for a system to have to bootstrap from
    environment.systemPackages = with pkgs; [
      curl
      git
      firefox
      pciutils
      vim
    ];
  };
}
