{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.profiles.development.node.enable = lib.mkEnableOption "node development";

  config = lib.mkIf config.my.home.profiles.development.node.enable {
    home = {
      packages = with pkgs; [
        nodePackages_latest.nodejs
      ];
    };

    my.home.profiles.development.enable = true;
  };
}
