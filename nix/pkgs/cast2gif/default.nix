{ lib, fetchFromGitHub, rustPlatform, cmake, stdenv, darwin, pkg-config, fontconfig }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  inherit (metadata) pname version;

  src = let inherit (metadata) fetch; in fetchFromGitHub fetch;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ]
    ++ (lib.optionals stdenv.isLinux [ fontconfig ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;[ CoreText ]));

  cargoLock.lockFile = ./Cargo.lock;

  meta = with lib; {
    description = "Render Asciinema cast files to gif";
    homepage = "https://github.com/katharostech/cast2gif";
    platforms = platforms.all;
  };
}
