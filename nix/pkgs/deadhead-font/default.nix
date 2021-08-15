{ lib, stdenv }:

stdenv.mkDerivation {
  pname = "deadhead-font";
  version = "0.1.0";
  src = ./.;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp deadhead-script-font.otf $out/share/fonts/opentype
  '';

  meta = with lib; {
    description = "";
    platforms = platforms.all;
  };
}
