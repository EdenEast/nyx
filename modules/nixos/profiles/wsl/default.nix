{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.nixos.profiles.wsl;
in {
  options.my.nixos.profiles.wsl = {
    enable = lib.mkEnableOption "printing support";
    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Set defualt user of wsl";
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      inherit (cfg) defaultUser;
      enable = true;
      wslConf = {
        automount.root = "/mnt";
        interop.appendWindowsPath = true;
      };
    };

    environment.systemPackages = with pkgs; [
      socat
      iproute2
    ];

    # Ensure that we dont enable network manager because we are on wsl
    networking.networkmanager.enable = lib.mkForce false;

    my.nixos.programs.nix.enable = true;
  };
}
