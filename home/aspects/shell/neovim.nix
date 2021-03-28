{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.shell.neovim;
in {
  options.nyx.aspects.shell.neovim = {
    enable = mkEnableOption "neovim configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ neovim-unwrapped ];
    xdg.configFile."nvim".source = ../../files/.config/nvim;
  };
}

