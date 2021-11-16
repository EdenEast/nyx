{ config, lib, pkgs, ... }:

{
  nyx.modules.user.home = ./home.nix;
}
