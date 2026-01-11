{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixos.programs.uutils.enable = lib.mkEnableOption "rust uutils coreutils replacement";

  config = lib.mkIf config.my.nixos.programs.uutils.enable {
    environment.systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
      (lib.hiPrio uutils-diffutils)
      (lib.hiPrio uutils-findutils)
    ];
  };
}
