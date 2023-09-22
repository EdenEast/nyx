{ lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nyx";
  version = "0.1.0";

  src = ./.;
  cargoLock.lockFile = ./Cargo.lock;
}
