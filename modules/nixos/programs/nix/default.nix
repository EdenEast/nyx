{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    nix = {
      channel.enable = false;
      distributedBuilds = true;

      gc = {
        automatic = true;

        dates = "weekly";
        options = "--delete-older-than 3d";

        persistent = true;
        randomizedDelaySec = "60min";
      };

      extraOptions = ''
        min-free = ${toString (1 * 1024 * 1024 * 1024)}   # 1 GiB
        max-free = ${toString (5 * 1024 * 1024 * 1024)}   # 5 GiB
      '';

      optimise = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "60min";
      };

      inherit (config.mySnippets.nix) settings;
    };

    programs.nix-ld.enable = true;
  };
}
