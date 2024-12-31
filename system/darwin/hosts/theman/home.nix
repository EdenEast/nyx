{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    bash
    coreutils-full
    moreutils
    ripgrep
    eza
    fd
    sd
    dua
    vhs
    just
    tuxmux
  ];

  # Manage home-manager with home-manager (inception)
  programs.home-manager.enable = true;

  # Install home-manager manpages.
  manual.manpages.enable = true;

  # Install man output for any Nix packages.
  programs.man.enable = true;

  nyx.modules = {
    app = {
      wezterm = {
        enable = true;
        package = null;
        fontSize = 14;
      };
    };
    dev = {
      rust.enable = true;
    };
    shell = {
      bash.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      lf.enable = true;
      neovim.enable = true;
      starship.enable = true;
      tmux.enable = true;
      xdg.enable = true;
      zoxide.enable = true;
      zsh.enable = true;

      gnupg = {
        enable = true;
        publicKeys = [{
          name = "personal.key";
          key = ../../../../config/.gnupg/public.key;
        }];
      };
    };
  };
}
