{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.niri = {
    enable = lib.mkEnableOption "niri desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.niri.enable {
    home.packages = with pkgs; [
      networkmanagerapplet
      alacritty
      swaybg # wallpaper
      xwayland-satellite
    ];

    xdg.configFile."niri/config.kdl".source = ./config.kdl;

    programs.waybar.enable = true;

    # services = {
    #   gnome-keyring.enable = true;
    #   # playerctld.enable = lib.mkDefault true;
    # };

    # programs.niri = {
    #   package = pkgs.niri;
    # };

    # myHome = {
    #   desktop.enable = true;
    #   programs.rofi.enable = true;
    #
    #   services = {
    #     hypridle.enable = true;
    #     mako.enable = true;
    #     swayosd.enable = true;
    #     waybar.enable = true;
    #   };
    # };
  };
}
