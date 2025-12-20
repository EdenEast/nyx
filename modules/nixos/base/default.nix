{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.base = {
    enable = lib.mkEnableOption "base system configuration";
  };

  config = lib.mkIf config.myNixOS.base.enable {
    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        curl
        libnotify
        lm_sensors
        vim
      ];

      variables = {
        inherit (config.myNixOS) FLAKE;
        NH_FLAKE = config.myNixOS.FLAKE;
      };
    };

    hardware = {
      keyboard.qmk.enable = true;
    };

    programs = {
      dconf.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      git.enable = true;
      nh.enable = true;
    };

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;

      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

    services = {
      cron.enable = true;
      locate.enable = true;

      logind.settings.Login = {
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
      };
    };

    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
