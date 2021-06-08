{ config, inputs, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.common;
in {
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

    environment.systemPackages = with pkgs; [
      # Audit
      audit
    ];

    nix = {
      autoOptimiseStore = true;
      sshServe.enable = true;
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

    nyx.modules = {
      user.enable = true;
    };

    # Silence warning about an invalid password hash.
    users.users.root.hashedPassword = null;
  };
}
