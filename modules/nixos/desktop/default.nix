{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./gnome
  ];

  options.myNixOS.desktop.enable = lib.mkOption {
    default = config.myNixOS.desktop.gnome.enable;
    description = "Desktop environment configuration.";
    type = lib.types.bool;
  };

  config = lib.mkIf config.myNixOS.desktop.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [gearlever];
    };

    home-manager.sharedModules = [
      {
        config.myHome.desktop.enable = true;
      }
    ];

    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };

      system-config-printer.enable = true;
    };

    services = {
      gnome.gnome-keyring.enable = true;
      libinput.enable = true;

      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
      };

      printing.enable = true;

      pulseaudio = {
        package = pkgs.pulseaudioFull; # Use extra Bluetooth codecs like aptX

        extraConfig = ''
          load-module module-bluetooth-discover
          load-module module-bluetooth-policy
          load-module module-switch-on-connect
        '';

        support32Bit = true;
      };

      system-config-printer.enable = true;
    };

    system.nixos.tags = ["desktop"];
  };
}
