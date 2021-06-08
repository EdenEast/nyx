{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.shell.neovim;
in {
  options.nyx.modules.shell.neovim = {
    enable = mkEnableOption "neovim configuration";
  };

  config = mkIf cfg.enable {
    # home.packages = with pkgs; [ neovim-unwrapped ];
    home.packages = with pkgs; [ neovim-nightly ];
    xdg.configFile."nvim".source = ../../../config/.config/nvim;
  };
}

