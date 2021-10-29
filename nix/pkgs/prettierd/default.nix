{ lib, fetchFromGitHub, mkYarnPackage, makeWrapper, nodejs }:

mkYarnPackage rec {
  pname = "prettierd";
  version = "0.18.0";
  src = fetchFromGitHub {
    owner = "fsouza";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-v46YeIBXaVzivUiw7xyJN3rJNfjSYDMsykejOKUjjNQ=";
  };

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    yarn --offline build
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/prettierd" \
      --add-flags $out/libexec/@fsouza/prettierd/deps/@fsouza/prettierd/dist/prettierd.js
  '';

  doDist = false;

  meta = with lib; {
    description = "prettier, as a daemon, for ludicrous formatting speed";
    homepage = "https://github.com/fsouza/prettierd";
    platforms = platforms.all;
  };
}
