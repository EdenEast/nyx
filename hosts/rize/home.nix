{self, ...}: {
  home-manager.users.eden = {
    imports = builtins.attrValues self.homeModules;

    config = {
      home = {
        homeDirectory = "/home/eden";
        stateVersion = "25.11";
        username = "eden";
      };

      my.home = {
        base.enable = true;

        programs = {
          fish.enable = true;
          nushell.enable = true;
          zsh.enable = true;

          claude.enable = true;
          neovim.useNightly = true;

          git = {
            enable = true;
            name = "EdenEast";
            email = "edenofest@gmail.com";
            key = "33FE803816CE6F0774145B13425E167F5B8FF416";
          };
        };

        services.gnupg.enable = true;

        profiles.development.rust.enable = true;
      };
    };
  };
}
