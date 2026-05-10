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

          git = {
            name = "EdenEast";
            email = "edenofest@gmail.com";
            key = "33FE803816CE6F0774145B13425E167F5B8FF416";
          };

          claude.enable = true;
          pi.enable = true;

          neovim.useNightly = true;
          spotify.enable = true;
          obsidian.enable = true;
          zen.enable = true;
        };

        profiles.development.rust.enable = true;

        services = {
          gnupg = {
            enable = true;
            publicKeys = [
              {
                key = self.configDir + "/.gnupg/public.asc";
              }
            ];
          };
        };
      };
    };
  };
}
