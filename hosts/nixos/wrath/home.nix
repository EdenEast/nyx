{self, ...}: {
  home-manager.users.eden = {
    config,
    lib,
    ...
  }: {
    home = {
      homeDirectory = "/home/eden";
      stateVersion = "25.11";
      username = "eden";
    };
  };
}
