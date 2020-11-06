{ config, lib, ... }:

{
  home.stateVersion = "20.09";
  nyx = {
    profiles = {
      development.enable = true;
    };
  };
}
