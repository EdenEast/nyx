{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Hardware ------------------------------------------------------------------
  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # ---------------------------------------------------------------------------

  networking.enableIPv6 = true;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.enp0s20f0u1.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # GPG and SSH
  # Enable for smartcard mode
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  environment.shellInit = ''
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  nyx.profiles.desktop.enable = true;

  system.stateVersion = "21.05";
}
