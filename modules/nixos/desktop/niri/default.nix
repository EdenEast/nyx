{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  options.myNixOS.desktop.niri = {
    enable = lib.mkEnableOption "hyprland desktop environment";
  };

  config = lib.mkIf config.myNixOS.desktop.niri.enable {
    home-manager.sharedModules = [
      {
        myHome.desktop.niri = {
          enable = true;
        };
      }
    ];

    programs.niri.enable = true;

    security.polkit.enable = true; # polkit
    services.gnome.gnome-keyring.enable = true; # secret service
    security.pam.services.swaylock = {};

    programs.waybar.enable = true; # top bar
    environment.systemPackages = with pkgs; [alacritty fuzzel swaylock mako swayidle];

    # Display manager
    services = {
      xserver.enable = true;
    };

    system.nixos.tags = ["niri"];
    myNixOS.desktop.enable = true;
  };
}
