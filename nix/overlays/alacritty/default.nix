self: super:

let metadata = import ./metadata.nix;
in {
  alacritty = super.alacritty.overrideAttrs (old: rec {
    version = "0.7.0-dev";
    src = super.fetchFromGitHub {
      owner = "alacritty";
      repo = "alacritty";
      rev = metadata.rev;
      sha256 = metadata.sha256;
    };

    cargoSha256 = metadata.cargoSha256;
  });
}

