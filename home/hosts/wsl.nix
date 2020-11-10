{ config, lib, ... }:

{
  home.stateVersion = "20.09";

  nyx = {
    aspects = {
      git = {
        userName = "James Simpson";
        userEmail = "edeofest@gmail.com";
      };
    };
    profiles = {
      development.enable = true;
    };
  };
}
