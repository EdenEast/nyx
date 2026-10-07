{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-CT1000BX500SSD1_2532E9C88DC5";
    content = {
      type = "gpt";
      partitions = {
        # GRUB embeds its boot image here when booting GPT disks through BIOS.
        bios = {
          size = "1M";
          type = "EF02";
          priority = 1;
        };
        boot = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
