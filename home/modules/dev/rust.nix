{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.dev.rust;
in
{
  options.nyx.modules.dev.rust = {
    enable = mkEnableOption "rust configuration";
    stableComponents = mkOption {
      description = "Which stable components to add, such as rustc, clippy or cargo";
      type = with types; listOf str;
      default = [
        "cargo"
        "rustc"
        "rust-src"
        "rust-docs"
        "rust-std"
        "clippy-preview"
        "rustfmt-preview"
      ];
    };

    nightlyComponents = mkOption {
      description = "Which nightly components to add, such as rustc, clippy or cargo";
      type = with types; listOf str;
      default = [ ];
    };

    rust-analyzer = mkOption {
      description = "Whether to add rust-analyzer";
      type = types.bool;
      default = true;
    };

    extraPackages = mkOption {
      description = "Extra packages to be installed with rust";
      type = with types; listOf package;
      default = with pkgs; [
        sccache
      ];
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        (fenix.stable.withComponents cfg.stableComponents)
        (fenix.latest.withComponents cfg.nightlyComponents)
      ] ++ cfg.extraPackages ++ (optional cfg.rust-analyzer fenix.rust-analyzer);

      sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
      };

      sessionPath = [ "$CARGO_HOME/bin" ];
    };
  };
}
