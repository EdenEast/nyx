{ lib, fetchCrate, rustPlatform, stdenv, }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  inherit (metadata) pname version;

  src = let inherit (metadata) fetch; in fetchCrate fetch;

  # Add missing Cargo.lock file
  patchPhase = ''
    cp -f ${./Cargo.lock} Cargo.lock
  '';

  cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "A tool for managing cargo workspaces and their crates, inspired by lerna";
    homepage = "https://github.com/pksunkara/cargo-workspaces";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
