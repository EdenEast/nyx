{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.dev.nix;
in {
  options.nyx.aspects.dev.nix = {
    enable = mkEnableOption "nix configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Code formatter for nix
      nixfmt
      # Source hash for fetchgit
      nix-prefetch-git
      # Source hash for github
      nix-prefetch-github
      # Current wip lsp for nix
      rnix-lsp
    ];
  };
}
