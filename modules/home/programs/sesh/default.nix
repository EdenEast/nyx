{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.programs.sesh;

  commonInitFunction =
    # sh
    ''
      function s() {
        local value=""
        if [ $# -gt 0 ]; then
          value="--value \"$@\""
        fi

        local selected=$(${lib.getExe cfg.package} list -id | ${lib.getExe pkgs.gum} filter --limit 1 \
          --no-sort --fuzzy $value --placeholder "Pick a sesh"  --select-if-one --height 40 --prompt="⚡")

        if [ -n "$selected" ]; then
          ${lib.getExe cfg.package} connect "$selected"
        fi
      }
    '';
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

      bash.initExtra = commonInitFunction;
      zsh.initContent = commonInitFunction;
      fish.functions.s =
        # fish
        ''
          set extra_args
          if test (count $argv) -gt 0
              set extra_args --value $argv[1]
          end

          set selected (
            ${lib.getExe cfg.package} list -id \
                | ${lib.getExe pkgs.gum} filter --select-if-one --no-sort --fuzzy \
                    --placeholder "Pick a sesh" \
                    --limit 1 \
                    --height 40 \
                    --prompt "⚡" \
                    $extra_args \
          )

          if test -n "$selected"
            ${lib.getExe cfg.package} connect $selected
          end
        '';
    };
  };
}
