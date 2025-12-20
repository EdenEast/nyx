{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # Base system definitions
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "wrath";
  system.stateVersion = "25.05";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";
  myNixOS = {
    base.enable = true;
    desktop.cosmic.enable = true;

    profiles = {
      audio.enable = true;
      bluetooth.enable = true;
      printing.enable = true;
    };

    programs = {
      uutils.enable = true;
    };

    services = {
      cosmic-greeter.enable = true;
    };
  };

  users.users.eden = {
    description = "EdenEast";
    isNormalUser = true;
    initialPassword = "pass";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "i2c"
      "vboxusers"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
