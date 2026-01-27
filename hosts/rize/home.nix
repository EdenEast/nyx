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

          neovim.useNightly = true;

          git = {
            name = "EdenEast";
            email = "edenofest@gmail.com";
            key = "5A038CEFD458DB47A6135B3F8316DECECB1A3F10";
            wsl = true;
          };
        };

        profiles.development.rust.enable = true;
      };
    };
  };
}
