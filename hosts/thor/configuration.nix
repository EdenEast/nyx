{lib, ...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./home.nix
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

  services.openssh.settings = {
    PermitRootLogin = "no";
    KbdInteractiveAuthentication = false;
  };

  # Enroll manually after installation; no encrypted auth key is needed to boot.
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = ["--operator=eden"];
  };

  my.nixos.base.enable = true;
  my.users = {
    defaultGroups = ["wheel" "networkmanager"];
    eden = {
      enable = true;
      # Allow public-key login, with no usable local password.
      password = "*";
    };
  };
}
