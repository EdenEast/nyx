{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Hardware ------------------------------------------------------------------
  boot = {
    # Change kernal to zen kernal
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [];
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

  nyx.modules.systemUser = {
    name = "eden";
    home = ./home.nix;
    hashedPassword = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
  };

  programs.steam.enable = true;

  networking.enableIPv6 = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  # networking.interfaces.enp0s20f0u1.useDHCP = true;

  # GPG and SSH
  # Enable for smartcard mode
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  environment.shellInit = ''
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  nyx.modules.nvidia = {
    enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  nyx.profiles.desktop = {
    enable = true;
  };
}
