{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
  ];

  boot = {
    supportedFilesystems = ["btrfs"];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];

    # Bootloader. As this computer is an OLD computer we need to use grub
    loader.grub = {
      enable = true;
      devices = lib.mkForce ["/dev/disk/by-id/ata-M4-CT128M4SSD2_000000001224090D56BE"];
    };
  };

  environment.systemPackages = [pkgs.btrfs-progs];
  fileSystems."/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "btrfs";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
