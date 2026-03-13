{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./disko.nix
  ];

  boot = {
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

  # # FileSystems ---------------------------------------------------------------
  # my.disko.installDrive = "/dev/disk/by-id/ata-M4-CT128M4SSD2_000000001224090D56BE ";
  # disko.devices.disk.main.content.partitions = {
  #   ESP.priority = lib.mkForce 2;
  #   MBR = {
  #     type = "EF02"; # for grub MBR
  #     size = "1M";
  #     priority = 1;
  #   };
  # };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/nixos";
  #   fsType = "ext4";
  # };
  #
  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-label/boot";
  #   fsType = "vfat";
  # };
  #
  # swapDevices = [
  #   {device = "/dev/disk/by-label/swap";}
  # ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
