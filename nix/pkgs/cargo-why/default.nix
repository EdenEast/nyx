{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-why";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "boringcactus";
    repo = pname;

    # Note: Repository does not have tags for releases
    rev = "9929b2077bcf832bb046261337b21e234167a21f";
    sha256 = "Jp4kQFAuCa4SiPz2h8EO/ZQwi5VNj1EiZ6mm/NK2LFM=";
  };

  cargoSha256 = "sha256-43/VxTrFxlyGgDnxu9+/9bg9Buqzd/XPajnKxhf7d/w=";

  meta = with lib; {
    description = "List features for a specific crate";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = licenses.mit;
  };
}
