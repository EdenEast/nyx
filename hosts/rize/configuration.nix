{inputs, ...}: {
  imports = [
    ./home.nix
  ];

  # Base system definitions
  networking.hostName = "rize";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  myNixOS = {
    base.enable = true;
    profiles = {
      wsl = {
        enable = true;
        defaultUser = "eden";
        # ssh-agent.enable = true;
      };
    };
  };

  # wsl.usbip = {
  #   enable = true;
  #   autoAttach = ["1-8"];
  # };

  myUsers.eden = {
    password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
    enable = true;
  };
}
