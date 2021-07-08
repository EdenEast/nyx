{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.dev.nix;
in
{
  options.nyx.modules.dev.nix = {
    enable = mkEnableOption "nix configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Code formatter for nix
      nixpkgs-fmt
      # Source hash for fetchgit
      nix-prefetch-git
      # Source hash for github
      nix-prefetch-github
      # Current wip lsp for nix
      rnix-lsp
    ];
  };
}
