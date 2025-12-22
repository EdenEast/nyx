{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nix-index-database.homeModules.nix-index];

  options.myHome.base = {
    enable = lib.mkEnableOption "base system configuration";
  };

  config = lib.mkIf config.myHome.base.enable {
    home = {
      packages = with pkgs; [
        # Collection of useful tools that aren't coreutils.
        moreutils
        # Mote interactive top (btm)
        bottom
        # Compress/uncompress `.zip` files.
        unzip
        zip
        # Man pages
        man
        man-pages
        man-pages-posix
        stdman
        bat
        # grep alternative.
        ripgrep
        # ls alternative.
        eza
        # Simple, fast and user-friendly alternative to find.
        fd
        # sed alternative
        sd
        # find files with SQL-like queries
        fselect
        # Interactive du with rm functionality
        dua
        # more intuitive du
        dust
        # A modern replacement for ps
        procs
      ];
    };

    # Manage home-manager with home-manager (inception)
    programs.home-manager.enable = true;

    # Install home-manager manpages.
    manual.manpages.enable = true;

    # Install man output for any Nix packages.
    programs.man.enable = true;

    programs.nix-index-database.comma.enable = true;
    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };

    myHome.programs = {
      ghostty.enable = true;
      git.enable = true;
      fish.enable = true;
      fzf.enable = true;
      jujutsu.enable = true;
      neovim.enable = true;
      starship.enable = true;
      tmux.enable = true;
      yazi.enable = true;
      zen.enable = true;
    };
  };
}
