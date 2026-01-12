{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  options.my.home.programs.spotify = {
    enable = lib.mkEnableOption "Spotify player";
  };

  config = lib.mkIf config.my.home.programs.spotify.enable {
    programs.spicetify = {
      enable = true;
      experimentalFeatures = true;
      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
        seekSong
        shuffle
      ];
      theme = spicePkgs.themes.comfy;
      windowManagerPatch = true;
    };
  };
}
