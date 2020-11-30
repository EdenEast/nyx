{ config, lib, pkgs, ... }:

with lib;
let cfg = config.nyx.aspects.dev.rust;
in {
  options.nyx.aspects.dev.rust = {
    enable = mkEnableOption "rust configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # rust toolchain installer
      rustup
      # modular compiler frontend and LSP for rust
      rust-analyzer
      # ccache with Cloud Storage
      sccache
    ];

    home = {
      sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
      };

      sessionPath = [ "$CARGO_HOME/bin" ];
    };
  };
}
