{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.aspects.dev.rust;
  cargoPkgs = with pkgs; [
    cargo-bloat
    cargo-deny
    cargo-edit
    cargo-expand
    cargo-license
    cargo-outdated
    cargo-udeps
    cargo-whatfeatures
    cargo-why
  ];
in {
  options.nyx.aspects.dev.rust = {
    enable = mkEnableOption "rust configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        # rust toolchain installer
        rustup
        # modular compiler frontend and LSP for rust
        rust-analyzer
        # ccache with Cloud Storage
        sccache

        # Needed by a lot of crates
        openssl
        pkg-config
      ] ++ cargoPkgs;

    home = {
      sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
      };

      sessionPath = [ "$CARGO_HOME/bin" ];
    };
  };
}
