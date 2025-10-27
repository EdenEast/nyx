{inputs, ...}: {
  imports = [
    ./home.nix
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  networking.hostName = "wrath";
  system.stateVersion = "25.05";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  hardware.keyboard.qmk.enable = true;

  myNixOS = {
    desktop.gnome.enable = true;

    services = {
      gdm.enable = true;
    };

    profiles = {
      base.enable = true;
    };
  };

  myUsers.eden = {
    enable = true;
    password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
  };
}
