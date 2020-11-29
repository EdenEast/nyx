{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.profiles.common;
in {
  options.nyx.profiles.common = { enable = mkEnableOption "common profilej"; };

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
        # Simple, fast and user-friendly alternative to find.
        fd
        # sed alternative
        sd
        # More intuitive du.
        du-dust
        # GnuPG
        gnupg
        # Visualize Nix gc-roots to delete to free space.
        nix-du
        # Encrypted files in Git repositories
        git-crypt
      ];
    };

    # Install home-manager manpages.
    manual.manpages.enable = true;

    # Install man output for any Nix packages.
    programs.man.enable = true;

    nyx.aspects = {
      shell.bash.enable = true;
      shell.git.enable = true;
      shell.gnupg.enable = true;
      shell.ssh.enable = true;
      shell.starship.enable = true;
      shell.xdg.enable = true;
    };
  };
}
