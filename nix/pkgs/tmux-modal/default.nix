{ lib, fetchFromGitHub, tmuxPlugins }:

tmuxPlugins.mkTmuxPlugin rec {
  pluginName = "tmux-modal";
  version = "0.1.0";
  rtpFilePath = "tmux-modal.tmux";

  src = fetchFromGitHub {
    owner = "whame";
    repo = "tmux-modal";
    rev = "020450abd9b9be83cedfebbdac20157727f215fd";
    sha256 = "sha256-OJIvoYFpfAWiInKD4Hg2VzF3G1ER3Kf2gbHukTUPH5E=";
  };

  meta = with lib; {
    description = "Add modal mode to tmux for easier command execution";
    homepage = "https://github.com/EdenEast/repo";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
