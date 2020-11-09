{ config, lib, ... }:

{
  home.stateVersion = "20.09";

  nyx = {
    configs = {
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
