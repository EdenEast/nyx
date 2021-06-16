self: super:

let metadata = import ./metadata.nix;
in {
  git-open = super.git-open.overrideAttrs (old: rec {
    version = "2.2.0-dev";
    src = super.fetchFromGitHub {
      owner = "paulirish";
      repo = "git-open";
      rev = metadata.rev;
      sha256 = metadata.sha256;
    };
  });
}
