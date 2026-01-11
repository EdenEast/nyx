{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./shells
    inputs.nix-index-database.homeModules.nix-index
  ];

  options.my.home.base = {
    enable = lib.mkEnableOption "base system configuration";
  };

  config = lib.mkIf config.my.home.base.enable {
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

    # Install home-manager manpages.
    manual.manpages.enable = true;

    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
        silent = true;
      };

      # Manage home-manager with home-manager (inception)
      home-manager.enable = true;

      # Install man output for any Nix packages.
      man.enable = true;

      nh.enable = true;

      nix-index-database.comma.enable = true;
      nix-index = {
        enable = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
    };

    my.home.programs = {
      ghostty.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      fzf.enable = lib.mkDefault true;
      jujutsu.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      zen.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
    };
  };
}
