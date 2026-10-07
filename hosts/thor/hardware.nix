# Starting hardware configuration. Replace with nixos-generate-config output
# using --no-filesystems on Thor. Disko owns the filesystems. See readme.md.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking.useDHCP = lib.mkDefault true;
}
