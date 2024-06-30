{ ... }:

_final: prev:

{
  tmux = prev.tmux.overrideAttrs (
    old: rec {
      version = "3.3a";
      src = prev.fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        rev = "${version}";
        sha256 = "sha256-SygHxTe7N4y7SdzKixPFQvqRRL57Fm8zWYHfTpW+yVY=";
      };
      patches = [ ];
    }
  );
}
