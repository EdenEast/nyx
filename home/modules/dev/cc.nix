{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.modules.dev.cc;
in
{
  options.nyx.modules.dev.cc = {
    enable = mkEnableOption "c/c++ configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # clang compiler
      # clang
      # clang-tidy, clang-format clang-check
      clang-tools
      # cross platform makefile generator
      # cmake
      # ccmake - curses cmake terminal frontend (contains cmake)
      cmakeCurses
      # formatter for cmake files
      cmake-format
      # TODO: fix collision between gcc and clang for cc
      # gnu compiler
      gcc
      # gnu debugger
      gdb
      # curses frontnend to gdb
      # cgdb
      gnumake
      # Faster build system to make
      ninja
    ];
  };
}
