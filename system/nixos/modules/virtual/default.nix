{ config, lib, pkgs, self, user, ... }:

with self.lib;
let
  cfg = config.nyx.modules.virtual;
in
{
  options.nyx.modules.virtual = {
    enable = mkEnableOption "virtualization support";
  };

  config = mkIf cfg.enable {
    # Enable dconf (System Management Tool)
    programs.dconf.enable = true;

    users.users."${config.nyx.modules.user.name}".extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      win-virtio
      win-spice
      gnome.adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };

    services.spice-vdagentd.enable = true;
  };
}
