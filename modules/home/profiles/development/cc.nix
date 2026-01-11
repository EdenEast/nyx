{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.profiles.development.cc.enable = lib.mkEnableOption "rust development";

  config = lib.mkIf config.my.home.profiles.development.cc.enable {
    home = {
      packages = with pkgs; [
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

    my.home.profiles.development.enable = true;
  };
}
