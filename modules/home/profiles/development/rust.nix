{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.home.profiles.development.rust.enable = lib.mkEnableOption "rust development";

  config = lib.mkIf config.my.home.profiles.development.rust.enable {
    home = {
      packages = with pkgs; [
        rustup
      ];

      sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
      };

      sessionPath = [
        "${config.xdg.dataHome}/cargo/bin"
      ];
    };

    my.home.profiles.development.enable = true;
  };
}
