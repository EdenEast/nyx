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
    boot = {
      # Enable running aarch64 binaries using qemu.
      binfmt.emulatedSystems = ["aarch64-linux"];

      # Clean temporary directory on boot.
      tmp.cleanOnBoot = true;

      # Enable support for nfs and ntfs.
      supportedFilesystems = ["cifs" "ntfs" "nfs"];
    };

    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        curl
        libnotify
        lm_sensors
        vim
        neovim
      ];

      sessionVariables = {
        EDITOR = "nvim";
      };

      variables = {
        inherit (config.myNixOS) FLAKE;
        NH_FLAKE = config.myNixOS.FLAKE;
      };
    };

    console = {
      font = "ter-124b";
      packages = [pkgs.terminus_font];
      earlySetup = true;
    };

    hardware = {
      enableAllFirmware = true;
      keyboard.qmk.enable = true;
    };

    programs = {
      dconf.enable = true;

      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
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

    myNixOS = {
      profiles = {
        bluetooth.enable = lib.mkDefault true;
        keymap.enable = lib.mkDefault true;
      };

      programs = {
        nix.enable = lib.mkDefault true;
        uutils.enable = lib.mkDefault true;
      };
    };
  };
}
