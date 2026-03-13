_: {
  imports = [
    ./hardware.nix
    ./secrets.nix
  ];

  # Base system definitions
  networking.hostName = "thor";
  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  my = {
    nixos = {
      base.enable = true;

      profiles = {
        keymap.enable = true;
      };

      services = {
        tailscale.enable = true;
      };
    };

    users.eden = {
      password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
      enable = true;
    };
  };
}
