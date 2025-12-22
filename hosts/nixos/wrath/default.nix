{inputs, ...}: {
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

    desktop = {
      cosmic.enable = true;
      laptop = true;
    };

    profiles = {
      audio.enable = true;
      printing.enable = true;
      gaming.enable = true;
    };

    services = {
      cosmic-greeter.enable = true;
      yubikey.enable = true;
    };
  };

  myUsers.eden = {
    password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
    enable = true;
  };
}
