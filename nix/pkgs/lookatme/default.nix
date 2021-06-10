{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "lookatme";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "d0c-s4vage";
    repo = "lookatme";
    rev = "v${version}";

    sha256 = "sha256-nTeCI1wFk8+5X7fROSmSIyydi0BzU7vvc+qJeQ+u4MM=";
  };

  checkInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages; [
    click
    marshmallow
    mistune
    pygments
    pyyaml
    urwid
  ];

  meta = {
    description = "An interactive, terminal-based markdown presenter";
    homepage = "https://github.com/d0c-s4vage/lookatme";
    license = lib.licenses.mit;
  };
}

