{ ... }:

_final: prev:

let
  rev = "14fdf5c96e30e89b84504d513a0311b3f712cee0";
  sha256 = "sha256-BXMjnGcrZ9zdoZplemv8jDL9OPsHES1BCEq/9Ui9fBw=";
in
{
  git-open = prev.git-open.overrideAttrs (
    old: rec {
      version = "2.2.0-dev";
      src = prev.fetchFromGitHub {
        owner = "paulirish";
        repo = "git-open";
        rev = rev;
        sha256 = sha256;
      };
    }
  );
}
