{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    coreutils-full
    moreutils
    ripgrep
    exa
    fd
    sd
    dua
    procs
  ];

  # Manage home-manager with home-manager (inception)
  programs.home-manager.enable = true;

  # Install home-manager manpages.
  manual.manpages.enable = true;

  # Install man output for any Nix packages.
  programs.man.enable = true;

  nyx.modules = {
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
    };
  };
}
