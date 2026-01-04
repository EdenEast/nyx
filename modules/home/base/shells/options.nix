{lib, ...}: {
  options.myHome.base.shells = {
    wsl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable wsl2-ssh-pageant to bridge between windows and wsl for yubikey support";
    };
  };
}
