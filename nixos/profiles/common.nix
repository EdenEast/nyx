{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.common;
  nixConf = import ../../nix/conf.nix;
in
{
  options.nyx.profiles.common = { enable = mkEnableOption "common profile"; };

  imports = [ inputs.nixpkgs.nixosModules.notDetected ];

  config = mkIf cfg.enable {
    boot = {
      # Enable running aarch64 binaries using qemu.
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      # Clean temporary directory on boot.
      cleanTmpDir = true;

      # Make memtest available as a boot option.
      loader = {
        grub.memtest86.enable = true;
        systemd-boot.memtest86.enable = true;
      };

      # Enable support for nfs and ntfs.
      supportedFilesystems = [ "cifs" "ntfs" "nfs" ];
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
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

    # security = {
    #   audit.enable = true;
    #   auditd.enable = true;

    #   sudo.extraConfig = ''
    #     Defaults insults
    #   '';
    # };

    services = {
      cron.enable = true;
      locate.enable = true;
    };

    # `nix-daemon` will hit the stack limit when using `nixFlakes`.
    systemd.services.nix-daemon.serviceConfig."LimitSTACK" = "infinity";

    time.timeZone = "America/Toronto";
    i18n.defaultLocale = "en_US.UTF-8";

    # List of bare minimal requirements for a system to have to bootstrap from
    environment.systemPackages = with pkgs; [
      vim
      git
      firefox
      pciutils
    ];

    nyx.modules = {
      # user.enable = true;
      yubikey.enable = true;
    };

    # Silence warning about an invalid password hash.
    users.users.root.hashedPassword = null;
  };
}
