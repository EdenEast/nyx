{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.profiles.development.rust.enable = lib.mkEnableOption "rust development";

  config = lib.mkIf config.myHome.profiles.development.rust.enable {
    home = {
      packages = with pkgs; [
        rustup
      ];

      sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
      };

      sessionPath = [
        "$CARGO_HOME/bin"
      ];
    };
  };
}
