{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.gaming.enable = lib.mkEnableOption "gaming optimizations";

  config = lib.mkIf config.myNixOS.profiles.gaming.enable {
    boot.kernelModules = ["ntsync"];

    environment.systemPackages = with pkgs; [
      heroic
      runelite
      switch-runelite
      (pkgs.writeShellScriptBin "switch-runelite" (builtins.readFile ./switch-runelite))
    ];

    myNixOS.programs.steam.enable = true;
  };
}
