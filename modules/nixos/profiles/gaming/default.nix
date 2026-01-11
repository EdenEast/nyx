{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixos.profiles.gaming.enable = lib.mkEnableOption "gaming optimizations";

  config = lib.mkIf config.my.nixos.profiles.gaming.enable {
    boot.kernelModules = ["ntsync"];

    environment.systemPackages = with pkgs; [
      heroic
      runelite
      (pkgs.writeShellScriptBin "switch-runelite" (builtins.readFile ./switch-runelite))
    ];

    my.nixos.programs.steam.enable = true;
  };
}
