{ lib, fetchFromGitHub, rustPlatform, cmake, stdenv, darwin, pkg-config, fontconfig }:

rustPlatform.buildRustPackage rec {
  pname = "cast2gif";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "katharostech";
    repo = "cast2gif";
    rev = "v${version}";

    sha256 = "sha256-4XFq3nZdlj6yX+hLojFWx4MhnPJL4l15dOGF/9zuiLY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ]
    ++ (lib.optionals stdenv.isLinux [ fontconfig ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;[ CoreText ]));

  cargoSha256 = "sha256-M3G9enFYzdsAAAo6XmGzr1VMcXfZjlf6xSMT8lIZtho=";

  meta = with lib; {
    description = "Render Asciinema cast files to gif";
    homepage = "https://github.com/katharostech/cast2gif";
    platforms = platforms.all;
  };
}
