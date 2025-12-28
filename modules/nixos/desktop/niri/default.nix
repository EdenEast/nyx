{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options.myNixOS.desktop.niri = {
    enable = lib.mkEnableOption "niri desktop environment";

    laptopMonitor = lib.mkOption {
      description = "Internal laptop monitor.";
      default = null;
      type = lib.types.nullOr lib.types.str;
    };

    monitors = lib.mkOption {
      description = "List of external monitors.";
      default = [];
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.desktop.niri.enable {
    home-manager.sharedModules = [
      {
        myHome.desktop.niri = {
          enable = true;
          inherit (config.myNixOS.desktop.niri) laptopMonitor;
          inherit (config.myNixOS.desktop.niri) monitors;
        };
      }
    ];

    security.polkit.enable = true; # polkit
    # services.gnome.gnome-keyring.enable = true; # secret service
    security.pam.services.swaylock = {};

    programs.niri = {
      enable = true;
      package = inputs.niri-src.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    system.nixos.tags = ["niri"];
    myNixOS.desktop.enable = true;
  };
}
