{ lib, pkgs, config, username, ... }:

pkgs.substituteAll {
  name = "syschdemd";
  src = ./syschdemd.sh;
  dir = "bin";
  isExecutable = true;

  buildInputs = with pkgs; [ daemonize ];

  inherit (pkgs) daemonize;
  inherit (config.security) wrapperDir;
  defaultUser = username;
  fsPackagesPath = lib.makeBinPath config.system.fsPackages;
}
