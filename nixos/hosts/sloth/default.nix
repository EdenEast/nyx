{ config, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Hardware ------------------------------------------------------------------

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
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

  # ---------------------------------------------------------------------------

  nyx.modules.systemUser = {
    name = "eden";
    home = ./home.nix;
    hashedPassword = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
  };

  networking.enableIPv6 = true;
  networking.interfaces.enp0s25.useDHCP = true;
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
}
