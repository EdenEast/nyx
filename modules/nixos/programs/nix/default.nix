{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than";
        persistent = true;
        randomizedDelaySec = "60min";
      };

      settings =
        {
          # Save space by hardlinking store files
          auto-optimise-store = true;

          allowed-users = ["root"];
        }
        // config.mySnippets.nix.settings;

      optimise = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "60min";
      };
    };
  };
}
