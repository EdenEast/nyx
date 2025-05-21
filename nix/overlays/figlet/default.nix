{...}: _final: prev: let
  extraFonts = prev.pkgs.fetchFromGitHub {
    owner = "xero";
    repo = "figlet-fonts";
    rev = "fb9fd8d2714fedea7594f00a546d80c0e541d624";
    sha256 = "sha256-eIyWMb3vSgQwWBeT/e2Y5zIPNkhAb0aMuWO9AcbfLoM=";
  };
in {
  figlet = prev.figlet.overrideAttrs (
    old: rec {
      postInstall = prev.lib.intersperse "\n" [
        old.postInstall
        ''
          cp -nr ${extraFonts}/*.flf $out/share/figlet/
        ''
      ];
    }
  );
}
