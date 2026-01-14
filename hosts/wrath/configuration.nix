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

  my = {
    nixos = {
      base.enable = true;

      desktop = {
        laptop = true;
        cosmic.enable = true;
        niri = {
          enable = true;
          laptopMonitor = ''
            output "eDP-1" {
              scale 1.25
            }
          '';
        };
      };

      profiles = {
        audio.enable = true;
        bluetooth.enable = true;
        gaming.enable = true;
        keymap.enable = true;
        printing.enable = true;
      };

      services = {
        cosmic-greeter.enable = true;
        yubikey.enable = true;
      };
    };

    users.eden = {
      password = "$6$nF.UDyrpHmh6M$yKCw56auQ7Dm1FfvmQg6y3Y59mWsoiHJyAYhqF9e8nKjfeKwUoFocwHhogKUTq.A3hVe9S.smv7u1NLV/yPTd0";
      enable = true;
    };
  };
}
