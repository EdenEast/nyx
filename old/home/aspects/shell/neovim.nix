{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.neovim;
in {
  options.nyx.aspects.shell.neovim = {
    enable = mkEnableOption "neovim configuration";
  };

  config = mkIf cfg.enable {
    # home.packages = with pkgs; [ neovim-unwrapped ];
    home.packages = with pkgs; [ neovim-nightly ];
    xdg.configFile."nvim".source = ../../files/.config/nvim;
  };
}

