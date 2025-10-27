{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        curl
        git
        htop
        lm_sensors
        pciutils
        vim
        wget
      ];

      variables = {
        FLAKE = lib.mkDefault "github:edeneast/nyx";
        NH_FLAKE = lib.mkDefault "github:edeneast/nyx";
      };
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;
    };

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;

      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

    services = {
      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };

      cron.enable = true;
      locate.enable = true;
    };

    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      nixos.tags = ["base"];
    };
  };
}
