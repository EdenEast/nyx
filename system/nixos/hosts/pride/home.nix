{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
  ];

  nyx = {
    modules = {
      app = {
        alacritty.fontSize = 8;
        wezterm.fontSize = 14;
        obs.enable = true;
      };
      dev = {
        cc.enable = true;
        nix.enable = true;
        node.enable = true;
      };
      shell = {
        direnv.enable = true;
        gnupg = {
          enable = true;
          publicKeys = [{
            key = ../../../../config/.gnupg/public.key;
          }];
        };
        repo = let r = import ../../../../home/common/repo.nix; in
          {
            enable = true;
            projects = r.projects;
            tags = r.tags;
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
