{
  config,
  lib,
  ...
}: {
  options.my.disko.installDrive = lib.mkOption {
    description = "Disk to install NixOS to.";
    default = "/dev/nvme0n1";
    type = lib.types.str;
  };

  config = {
    assertions = [
      {
        assertion = config.my.disko.installDrive != "";
        message = "config.myDisko.installDrive cannot be empty.";
      }
    ];

    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = config.my.disko.installDrive;

          content = {
            type = "gpt";

            partitions = {
              ESP = {
                content = {
                  format = "vfat";
                  mountOptions = ["umask=0077"];
                  mountpoint = "/boot";
                  type = "filesystem";
                };

                end = "1024M";
                name = "ESP";
                priority = 1;
                start = "1M";
                type = "EF00";
              };

              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];

                  subvolumes = {
                    "/rootfs" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/";
                    };

                    "/home" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/home";
                    };

                    "/home/.snapshots" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/home/.snapshots";
                    };

                    "/nix" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/nix";
                    };
                  };

                  mountpoint = "/partition-root";
                };
              };
            };
          };
        };
      };
    };
  };
}
