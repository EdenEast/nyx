{
  lib,
  fetchCrate,
  rustPlatform,
}: let
  metadata = import ./metadata.nix;
in
  rustPlatform.buildRustPackage rec {
    inherit (metadata) pname version;

    src = fetchCrate metadata;

    cargoLock.lockFile = ./Cargo.lock;

    meta = with lib; {
      description = "A TUI file explorer";
      homepage = "https://github.com/sayanarijit/xplr";
      license = licenses.mit;
      platforms = platforms.all;
    };
  }
