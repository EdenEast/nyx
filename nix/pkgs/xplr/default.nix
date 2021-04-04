{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "xplr";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "sayanarijit";
    repo = "xplr";
    rev = "8dae2fef4da48d612d54a9d2e643b2627baa2719";

    sha256 = "sha256-4PZZ8NNHhorF3luNfbyb1NztvhldFprPPmoK+JtzhjI=";
  };

  # nativeBuildInputs = [ pkg-config ];
  # buildInputs = [ openssl ];

  cargoSha256 = "sha256-DYsawCjlWm+Nsm/F517wczfZBwdiKxn/CrXBkcnEo1s=";

  meta = with lib; {
    description = "A TUI file explorer";
    homepage = "https://github.com/sayanarijit/xplr";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

