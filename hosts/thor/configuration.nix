{lib, ...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./home.nix
    ./secrets.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "thor";
  system.stateVersion = "26.05";

  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  # Disko's BIOS boot partition sets GRUB's target to the disk in disko.nix.
  boot.loader.grub.enable = true;

  # Keep the machine available for SSH and long-running development sessions.
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
  services.logind.settings.Login.HandlePowerKey = lib.mkForce "poweroff";
  services.logind.settings.Login.KillUserProcesses = false;

  # services.openssh.settings = {
  #   PermitRootLogin = "no";
  #   KbdInteractiveAuthentication = false;
  # };

  # Authorize the setup client's hardware-backed key on Thor.
  users.users.eden.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaVyoWBnLFIPWE4L2FdfPH//j+/+YgCmc6jJYme7AwZ eden@rize"
  ];

  my = {
    nixos = {
      base.enable = true;
      services.tailscale = {
        enable = true;
        operator = "eden";
      };
    };
    users = {
      defaultGroups = ["wheel" "networkmanager"];
      eden = {
        enable = true;
        password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
      };
    };
  };
}
