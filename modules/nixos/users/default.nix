{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./eden.nix
  ];

  options.myUsers = let
    mkUser = user: {
      enable = lib.mkEnableOption "${user}.";
      username = lib.mkOption {
        type = lib.types.string;
        default = "${user}";
        description = "User's name";
      };

      password = lib.mkOption {
        default = null;
        description = "Hashed password for ${user}.";
        type = lib.types.nullOr lib.types.str;
      };
    };
  in {
    defaultGroups = lib.mkOption {
      description = "Default groups for desktop users.";
      default = [
        "cdrom"
        "dialout"
        "docker"
        "libvirtd"
        "lp"
        "networkmanager"
        "plugdev"
        "scanner"
        "transmission"
        "video"
        "wheel"
      ];
    };

    root.enable = lib.mkEnableOption "root user configuration." // {default = true;};
    eden = mkUser "eden";
  };

  config = lib.mkIf (config.myUsers.root.enable or config.myUsers.eden) {
    programs.zsh.enable = true;

    users = {
      defaultUserShell = pkgs.zsh;
      mutableUsers = false;
    };
  };
}
