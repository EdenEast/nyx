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
        # grep alternative.
        ripgrep
        # ls alternative.
        exa
        # cat alternative.
        bat
        # Simple, fast and user-friendly alternative to find.
        fd
        # More intuitive du.
        du-dust
        # cat for markdown
        mdcat
        # Keybase
        keybase
        # Hosted binary caches
        cachix
      ];
    };

    # Install home-manager manpages.
    manual.manpages.enable = true;

    # Install man output for any Nix packages.
    programs.man.enable = true;

    # nyx.configs = {
    # };
  };
}
