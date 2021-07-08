{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.31";
  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-4NdD+WwvlqfJdPqXTz9LUyriJyLPppi8jH6dxYupe6A=";
  };

  vendorSha256 = "sha256-tca+1SRrFyvU8ttHmfMFiGXd1A8rQSEWm1Mc2qp0EfI=";

  meta = with lib; {
    description = "General purpose Language Server";
    homepage = "https://github.com/mattn/efm-langserver";
    platforms = platforms.all;
  };
}

