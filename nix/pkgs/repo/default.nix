{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

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

  cargoSha256 = "sha256-eM862A//UpvSxu1Ij9gy52qr10RhTNq3eN9qnHA4Bss=";

  meta = with stdenv.lib; {
    description = "Repository management system";
    homepage = "https://github.com/EdenEast/repo";
    license = licenses.mit;
    maintainers = with maintainers; [ edeneast ];
    platforms = platforms.all;
  };
}
