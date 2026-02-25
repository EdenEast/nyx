{
  config,
  lib,
  ...
}: {
  options.my.disko.installDrive = lib.mkOption {
    description = "Disk to install NixOS to.";
    default = "/dev/sda";
    type = lib.types.str;
  };

  config = {
    assertions = [
      {
        assertion = config.my.disko.installDrive != "";
        message = "config.my.disko.installDrive cannot be empty.";
      }
    ];

    disko.devices = {
      disk = {
        main = {
          device = config.my.disko.installDrive;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                type = "EF00";
                size = "1024M";
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
      };
    };
  };
}
