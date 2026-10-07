{self, ...}: {
  home-manager.users.eden = {
    imports = builtins.attrValues self.homeModules;

    home = {
      username = "eden";
      homeDirectory = "/home/eden";
      stateVersion = "26.05";
    };

    my.home = {
      base.enable = true;
      programs = {
        fish.enable = true;
        git = {
          enable = true;
          name = "EdenEast";
          email = "edenofest@gmail.com";
        };
      };
      profiles.development = {
        node.enable = true;
        python.enable = true;
        rust.enable = true;
      };
    };
  };
}
