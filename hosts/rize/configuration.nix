_: {
  imports = [
    ./home.nix
  ];

  # Base system definitions
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "rize";
  system.stateVersion = "25.11";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  my = {
    nixos = {
      base.enable = true;
      profiles.wsl = {
        enable = true;
        defaultUser = "eden";
      };
    };

    users.eden = {
      password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
      enable = true;
    };
  };
}
