{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.programs.sesh;
  commonAlias = "${cfg.package} connect $(${cfg.package} list -id | ${pkgs.gum} filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 40 --prompt='⚡')";
in {
  options.my.home.programs.sesh = {
    enable = lib.mkEnableOption "tmux session manager";
    package = lib.mkPackageOption pkgs "sesh" {};
  };

  config = lib.mkIf config.my.home.programs.sesh.enable {
    programs = {
      sesh = {
        enable = true;
        enableAlias = false;
        enableTmuxIntegration = false;
      };

      bash.shellAliases.s = commonAlias;
      zsh.shellAliases.s = commonAlias;
      fish.shellAliases.s = ''${lib.getExe cfg.package} connect (${lib.getExe cfg.package} list -id | ${lib.getExe pkgs.gum} filter --limit 1 --fuzzy --no-sort --placeholder "Pick a sesh" --height 40 --prompt="⚡")'';
    };
  };
}
