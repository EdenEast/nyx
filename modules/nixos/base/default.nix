{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.my.nixos.base = {
    enable = lib.mkEnableOption "base system configuration";
    editor = lib.mkOption {
      type = lib.types.package;
      description = "Default editor package";
      default = pkgs.neovim;
    };

    domain = lib.mkOption {
      description = "Base domain name to be used to access the homelab services via Caddy reverse proxy";
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkIf config.my.nixos.base.enable {
    boot = {
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
        config.my.nixos.base.editor
      ];

      variables = {
        inherit (config.my.nixos) FLAKE;
        NH_FLAKE = config.my.nixos.FLAKE;

        EDITOR = "nvim";
        VISUAL = "nvim";
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
      git.enable = true;
      nh.enable = true;
      ssh.knownHosts = config.my.snippets.ssh.knownHosts;

      nix-index-database.comma.enable = true;
      nix-index = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
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

    my.nixos = {
      programs = {
        nix.enable = lib.mkDefault true;
        uutils.enable = lib.mkDefault true;
      };

      services.openssh.enable = lib.mkDefault true;
    };
  };
}
