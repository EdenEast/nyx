{ lib, rustPlatform, fetchFromGitHub, openssl, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "oeNZViTVW3phcgxioFORYGJtWAvmB5bUL+E92+8ZcW4=";
  };

  cargoSha256 = "nNV7UXjKZNFmTqW4H0qsNuBW9XOP2V9nfotewtI9mYE=";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "List features for a specific crate";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = licenses.mit;
  };
}
