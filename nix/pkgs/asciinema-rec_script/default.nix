{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "asciinema-rec_script";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zechris";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iEr4YPgYYZlWlkDoxxMv2ix8uYi4n1D/3ZWRAuZQYxg=";
  };

  dontConfigure = true;
  dontBuild = true;

  patches = [
    ./0001-patch-version.patch
  ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin bin/asciinema-rec_script
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/zechris/asciinema-rec_script";
    description = "Record, comments and, commands from from shell scripts in addition to their output";
    license = lib.licenses.gpl3;
  };
}
