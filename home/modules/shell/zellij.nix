{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.nyx.modules.shell.zellij;
  zellij-autolock = pkgs.stdenv.mkDerivation rec {
    pname = "zellij-autolock";
    version = "0.2.0";

    src = builtins.fetchurl {
      url = "https://github.com/fresh2dev/zellij-autolock/releases/download/${version}/zellij-autolock.wasm";
      sha256 = "sha256:0k61zy8lbd8n4aqky93vi6qbfxfwzxqajlf1rpczn1755v9bslzb";
    };
    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/zellij_autolock.wasm
    '';
  };
in
{
  options.nyx.modules.shell.zellij = {
    enable = mkEnableOption "zellij configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.zellij ];
    xdg.configFile."zellij".source = ../../../config/.config/zellij;
    xdg.dataFile."zellij/plugins/zellij-autolock".source = "${zellij-autolock}/bin/zellij-autolock";
  };
}
