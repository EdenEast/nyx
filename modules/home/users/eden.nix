{
  self,
  config,
  pkgs,
  ...
}: {
  config = {
    home = {
      homeDirectory = "/home/eden";
      username = "eden";
      stateVersion = "25.05";
    };

    # programs.home-manager.enable = true;
    # xdg.enable = true;
  };
}
