{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixos.programs.steam = {
    enable = lib.mkEnableOption "Steam client";
    session.enable = lib.mkEnableOption "Steam + Gamescope desktop session";
  };

  config = lib.mkIf config.my.nixos.programs.steam.enable {
    hardware.steam-hardware.enable = true;

    programs = {
      gamescope.enable = true;

      steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        extest.enable = true;
        extraCompatPackages = with pkgs; [proton-ge-bin];
        gamescopeSession.enable = config.my.nixos.programs.steam.session.enable;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };

    hardware.graphics = {
      extraPackages = [pkgs.mangohud];
      extraPackages32 = [pkgs.mangohud];
    };
  };
}
