{ lib, fetchCrate, rustPlatform, openssl, pkg-config, stdenv, libiconv, darwin }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  inherit (metadata) pname version;

  src = let inherit (metadata) fetch; in fetchCrate fetch;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libiconv ]
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;[ Security ]));

  cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "Repository management system";
    homepage = "https://github.com/EdenEast/repo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
