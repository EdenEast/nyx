{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config, stdenv, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "repo";
  version = "0.1.3-dev";

  src = fetchFromGitHub {
    owner = "EdenEast";
    repo = "repo";
    rev = "2379ed5a1e348f0274d0941245037a4c9f9c2dd2";

    sha256 = "sha256-pbgS9+PRvamFPMFj9DD/1iceAQv8wdWLJR2E2U8HcHs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libiconv ] ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;[ Security ]));

  cargoSha256 = "sha256-NnEMOikoxT6Fcx2jSiq/OUjRCInOINm+bD1xrxlf0Do=";

  meta = with lib; {
    description = "Repository management system";
    homepage = "https://github.com/EdenEast/repo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
