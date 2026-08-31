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
        nodejs
      ];
    };

    my.home.profiles.development.enable = true;
  };
}
