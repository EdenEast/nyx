{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.dev.lua;
in {

  options.nyx.aspects.dev.lua = {
    enable = mkEnableOption "lua configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lua52Packages.lua lua52Packages.lua-lsp ];
  };
}
