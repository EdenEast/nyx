{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.desktop;

  wmList = [ "awesome" ];
  deList = [ "gnome" "plasma5" ];
in
{
  options.nyx.profiles.desktop = {
    laptop = mkOption {
      description = "Enable features for a laptop (trackpad, battery, etc...)";
      type = types.bool;
      default = false;
    };

    flavor = mkOption {
      description = "Desktop environment flavor";
      type = types.enum (wmList ++ deList);
      default = "awesome";
    };
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;

    # Sound setting
    sound.enable = true;

    environment.systemPackages = with pkgs; [
      pamixer
      firefox
    ];

    hardware = {
      pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };
    };

    # Desktop environment flavor
    services.xserver = {
      enable = true;
      layout = "us";
      libinput = mkIf cfg.laptop {
        enable = true;
        touchpad.tapping = true;
      };

      displayManager = {
        lightdm.enable = cfg.flavor != "gnome";
        gdm.enable = cfg.flavor == "gnome";
        # session = [
        #   {
        #     name = "home-manager";
        #     manage = "window";
        #     start = ''
        #       ${pkgs.runtimeShell} $HOME/.hm-xsession &
        #       waitPID=$!
        #     '';
        #   }
        # ];
      };
    };

    services.xserver.desktopManager = mkIf (elem "${cfg.flavor}" deList) {
      gnome.enable = mkIf (cfg.flavor == "gnome") true;
      plasma5.enable = mkIf (cfg.flavor == "plasma5") true;
    };

    services.xserver.windowManager = mkIf (elem "${cfg.flavor}" wmList) {
      awesome.enable = mkIf (cfg.flavor == "awesome") true;
    };
  };
}
