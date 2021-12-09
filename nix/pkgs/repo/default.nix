{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "repo";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "EdenEast";
    repo = "repo";
    rev = "v${version}";

    sha256 = "sha256-muPzAMoX0PPwxtvjeKEWBlGIj1fEU9IXqjLBWb9LkhQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libiconv ] ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;[ Security ]));

  cargoSha256 = "sha256-WyhG+lUCi3ARMxa64h6SMMi1aileH4K8sm9un0B1+NU=";

  meta = with lib; {
    description = "Repository management system";
    homepage = "https://github.com/EdenEast/repo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
