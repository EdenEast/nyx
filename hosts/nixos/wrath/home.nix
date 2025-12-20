{self, ...}: {
  home-manager.users.eden = {
    imports = [
      self.homeModules.default
    ];
    config = {
      home = {
        homeDirectory = "/home/eden";
        stateVersion = "25.11";
        username = "eden";
      };

      myHome = {
        base.enable = true;

        programs = {
          ghostty.enable = true;
          git.enable = true;
          jujutsu.enable = true;
          neovim.enable = true;
          obsidian.enable = true;
          starship.enable = true;
          tmux.enable = true;
          zen.enable = true;
        };
      };
    };
  };
}
