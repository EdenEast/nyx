{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "repo";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "EdenEast";
    repo = "repo";
    rev = "v${version}";

    sha256 = "sha256-Ewtc80mtToNaUHkXeE+pUJ3cW7BTy9BGpmKmqboGzPc=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoSha256 = "sha256-3DtZyAVOBxl9jEJdSRJbVUGnGXKVKt533dQfmy5KuxE=";

  meta = with lib; {
    description = "Repository management system";
    homepage = "https://github.com/EdenEast/repo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
