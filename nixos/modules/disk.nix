{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.disk;
in
{
  options.nyx.modules.disk.enable = mkEnableOption "disk utilities and file managers";

  config = mkIf cfg.enable {
    # udiskctl service to manipulate storage devices. Mount and unmount without the need for sudo
    services.udisks2.enable = true;

    # Userspace virtual file system
    services.gvfs.enable = true;

    # Enable thumbnail service
    services.tumbler.enable = true;

    # Install thunar and accompanying volumne manager used for automounting drives.
    # Installing thunar as it does not have that many other dependencies
    # unlike something like dolphin for kde or nautilus for gnome
    environment.systemPackages = with pkgs.xfce; [
      thunar
      thunar-volman
    ];
  };
}
