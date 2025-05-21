{pkgs, ...}: {
  home.packages = with pkgs; [
    rustup
    vhs
    chromium # required by vhs
  ];

  nyx = {
    modules = {
      app = {
        alacritty.fontSize = 8;
        ghostty.enable = true;
        obsidian.enable = true;
        wezterm.fontSize = 12;
        obs.enable = true;
      };
      dev = {
        cc.enable = true;
        rust.enable = true;
      };
      shell = {
        direnv.enable = true;
        gnupg = {
          enable = true;
          publicKeys = [
            {
              key = ../../../../config/.gnupg/public.key;
            }
          ];
        };

        repo = {
          # enable = true;
          projects = {
            nightfox = {
              name = "nightfox.nvim";
              remote = "ssh://git@github.com/edeneast/nightfox.nvim.git";
              tags = ["plugins"];
            };
            qmk = {
              remote = "ssh://git@github.com/edeneast/qmk.git";
              tags = ["keyboard"];
            };
          };
          tags = {
            app = {
              path = "app";
            };
            plugins = {
              path = "plugins";
            };
            site = {
              path = "site";
            };
          };
        };
      };
    };

    profiles = {
      common.enable = true;
      extended.enable = true;
      desktop = {
        enable = true;
        laptop = true;
      };
      development.enable = true;
    };
  };
}
