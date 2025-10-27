{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  home-manager.users.eden = {
    imports = [
      self.homeModules.default
      self.homeModules.eden
    ];

    config = {
      home.packages = with pkgs; [
      ];

      myHome = {
        programs = {
          ghostty.enable = true;
        };
      };
    };
  };
}
