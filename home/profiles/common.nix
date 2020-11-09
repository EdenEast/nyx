{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.profiles.common;
in
{
  options.nyx.profiles.common = {
    enable = mkEnableOption "common configurations";
  };

  config = mkIf cfg.enable {
    home = {
      enableDebugInfo = true;
      packages = with pkgs; [
        # Determine file type.
        file
        # Show full path of shell commands.
        which
        # Daemon to execute scheduled commands.
        cron
        # Collection of useful tools that aren't coreutils.
        moreutils
        # Non-interactive network downloader.
        wget
        # List directory contents in tree-like format.
        tree
        # Interactive process viewer.
        htop
        # Top-like I/O monitor.
        iotop
        # Power consumption and management diagnosis tool.
        powertop
        # Bandwidth monitor and rate estimator.
        bmon
        # Dump traffic on a network.
        tcpdump
        # Compress/uncompress `.zip` files.
        unzip
        zip
        # Man pages
        man
        man-pages
        posix_man_pages
        stdman
        # Index the nix store (provides `nix-locate`).
        nix-index
        # Eases nixpkgs review workflow.
        nix-review
        # grep alternative.
        ripgrep
        # ls alternative.
        exa
        # cat alternative.
        bat
        # GnuPG
        gnupg
        # A command-line tool to generate, analyze, convert and manipulate colors.
        pastel
        # Tool for indexing, slicing, analyzing, splitting and joining CSV files.
        xsv
        # Simple, fast and user-friendly alternative to find.
        fd
        # More intuitive du.
        du-dust
        # Command line image viewer
        viu
        # Tool for discovering and probing hosts on a computer network
        arping
        # Visualize Nix gc-roots to delete to free space.
        nix-du
        # Recover dead disks :(
        ddrescue
        # Encrypted files in Git repositories
        git-crypt
        # Keybase
        keybase
        # Hosted binary caches
        cachix
      ];

      # sessionVariables = { };
    };

    # Install home-manager manpages.
    manual.manpages.enable = true;

    # Install man output for any Nix packages.
    programs.man.enable = true;

    nyx.configs = {
      starship.enable = true;
      lf.enable = true;
      git.enable = true;
    };
  };
}
