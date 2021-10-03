{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.profiles.common;
in
{
  options.nyx.profiles.common = { enable = mkEnableOption "common profile"; };

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
        # Mote interactive top (btm)
        bottom
        # Compress/uncompress `.zip` files.
        unzip
        zip
        # Man pages
        man
        man-pages
        posix_man_pages
        stdman
        # grep alternative.
        ripgrep
        # ls alternative.
        exa
        # Simple, fast and user-friendly alternative to find.
        fd
        # sed alternative
        sd
        # Interactive du with rm functionality
        dua
        # A modern replacement for ps
        procs
        # Encrypted files in Git repositories
        git-crypt
      ];
    };

    # Manage home-manager with home-manager (inception)
    programs.home-manager.enable = true;

    # Install home-manager manpages.
    manual.manpages.enable = true;

    # Install man output for any Nix packages.
    programs.man.enable = true;

    nyx.modules = {
      shell.bash.enable = true;
      shell.bat.enable = true;
      shell.git.enable = true;
      # shell.gnupg.enable = true;
      shell.neovim.enable = true;
      shell.nushell.enable = true;
      # shell.ssh.enable = true;
      shell.starship.enable = true;
      shell.xdg.enable = true;
    };
  };
}
