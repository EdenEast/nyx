{ config, lib, ... }:

{
  home.stateVersion = "20.09";

  nyx = {
    aspects = {
      shell.git = {
        userName = "James Simpson";
        userEmail = "edeofest@gmail.com";
      };
    };
    profiles = {
      development.enable = true;
      extended.enable = true;
    };
  };
}
